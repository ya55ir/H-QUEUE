class QueueEntry < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :venue

  enum :status, { waiting: 0, notified: 1, confirmed: 2, seated: 3, cancelled: 4 }

  STALE_AFTER = 24.hours
  ACTIVE_STATUSES = %i[waiting notified confirmed].freeze

  validates :party_size, presence: true, numericality: { greater_than: 0 }
  validates :name, presence: true, if: -> { user.nil? }
  validates :phone_number, presence: true, if: -> { user.nil? }
  validate :phone_number_format, if: -> { user.nil? && phone_number.present? }

  before_validation :expire_stale_entries, on: :create
  validate :not_already_in_queue, on: :create

  after_commit :broadcast_queue_refresh, on: %i[create update]

  # Nombre de groupes de même taille arrivés avant celui-ci, dans le même venue
  def tables_ahead
    venue.queue_entries
         .where(status: :waiting, party_size: party_size)
         .where("created_at < ?", created_at)
         .count
  end

  def parties_ahead
    venue.queue_entries
         .where(status: :waiting)
         .where("created_at < ?", created_at)
         .count
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

  def display_phone
    phone_number.presence || user&.phone_number
  end

  # Point de départ du chrono affiché sur la carte : depuis la notification si notifié, sinon depuis l'arrivée
  def waiting_since
    notified_at || created_at
  end

  private

  # Une entrée qui attend ou a été notifiée depuis plus de STALE_AFTER n'est plus valable :
  # on la passe à "cancelled" pour libérer la place du client dans ce venue.
  def expire_stale_entries
    venue.queue_entries
         .where(status: %i[waiting notified])
         .where("created_at < ?", STALE_AFTER.ago)
         .update_all(status: :cancelled)
  end

  def not_already_in_queue
    scope = venue.queue_entries.where(status: ACTIVE_STATUSES)
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
