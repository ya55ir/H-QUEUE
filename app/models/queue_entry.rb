class QueueEntry < ApplicationRecord
  belongs_to :user
  belongs_to :venue

  enum :status, { waiting: 0, notified: 1, confirmed: 2, seated: 3, cancelled: 4 }

  validates :party_size, presence: true, numericality: { greater_than: 0 }

  # Nombre de groupes de même taille arrivés avant celui-ci, dans le même venue
  def tables_ahead
    venue.queue_entries
         .where(status: :waiting, party_size: party_size)
         .where("created_at < ?", created_at)
         .count
  end
end
