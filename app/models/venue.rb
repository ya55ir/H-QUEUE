class Venue < ApplicationRecord
  has_many :table_types, dependent: :destroy
  has_many :queue_entries, dependent: :destroy

  validates :name, :address, presence: true
  validates :avg_wait_minutes, numericality: { greater_than: 0 }, allow_nil: true
end
