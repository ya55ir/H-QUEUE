class QueueEntry < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :venue

  enum :status, { waiting: 0, notified: 1, confirmed: 2, seated: 3, cancelled: 4 }

  validates :party_size, presence: true, numericality: { greater_than: 0 }
  validates :name, :phone_number, presence: true, if: -> { user.nil? }

  # Nombre de groupes de même taille arrivés avant celui-ci, dans le même venue
  def tables_ahead
    venue.queue_entries
         .where(status: :waiting, party_size: party_size)
         .where("created_at < ?", created_at)
         .count
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
end
