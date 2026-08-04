class QueueEntry < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :venue

  enum :status, { waiting: 0, notified: 1, confirmed: 2, seated: 3, cancelled: 4 }

  ACTIVE_STATUSES = %i[waiting notified confirmed].freeze

  scope :active, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  validates :party_size, presence: true, numericality: { greater_than: 0 }
  validates :name, presence: true, if: -> { user.nil? }
  validates :phone_number, presence: true, if: -> { user.nil? }
  validate :phone_number_format, if: -> { user.nil? && phone_number.present? }

  validate :not_already_in_queue, on: :create

  after_commit :broadcast_queue_refresh, on: %i[create update]

  # Nombre de groupes de même taille arrivés avant celui-ci, dans le même venue
  def tables_ahead
    venue.queue_entries.active
         .where(status: :waiting, party_size: party_size)
         .where("created_at < ?", created_at)
         .count
  end

  def parties_ahead
    venue.queue_entries.active
         .where(status: :waiting)
         .where("created_at < ?", created_at)
         .count
  end

  def archived?
    archived_at.present?
  end

  def estimated_wait_minutes
    return 0 if parties_ahead.zero?

    tables_at_venue = venue.table_types.count
    return venue.avg_wait_minutes if tables_at_venue.zero?

    waves = (parties_ahead.to_f / tables_at_venue).ceil
    waves * venue.avg_wait_minutes
  end

  def display_name
    name.presence || [user&.first_name, user&.last_name].compact.join(" ")
  end

  def share_message
    "Come join me at #{venue.name} (#{venue.address}), our table is ready!"
  end

  def display_phone
    phone_number.presence || user&.phone_number
  end

  # Point de départ du chrono affiché sur la carte : depuis la notification si notifié, sinon depuis l'arrivée
  def waiting_since
    notified_at || created_at
  end

  class << self
    # Reset quotidien (1h du matin, cf ArchiveDailyQueueJob) : on archive tout ce qui reste
    # de la veille dans chaque venue, peu importe le statut, pour repartir sur une file vide.
    # On garde le statut d'origine (waiting/notified/confirmed/cancelled/seated) pour l'historique,
    # on marque juste la sortie de la file active via archived_at.
    # update! (et non update_all) pour déclencher les callbacks : un client dont l'entrée est
    # archivée doit être notifié en direct (broadcast_queue_refresh) plutôt que de rester
    # bloqué sur son écran de suivi de file.
    def archive_daily!
      active.find_each { |entry| entry.update!(archived_at: Time.current) }
    end
  end

  private

  def not_already_in_queue
    scope = venue.queue_entries.active.where(status: ACTIVE_STATUSES)
    scope = user ? scope.where(user_id: user.id) : scope.where(phone_number: phone_number)

    errors.add(:base, "You are already in this queue") if scope.exists?
  end

  def phone_number_format
    digits = phone_number.gsub(/[^\d+]/, "")
    return if digits =~ /\A\+?\d{9,15}\z/

    errors.add(:phone_number, "n'est pas un numéro de téléphone valide")
  end

  # Signale à tous les clients qui consultent la page du venue de se rafraîchir
  def broadcast_queue_refresh
    broadcast_refresh_to(venue)
  end
end
