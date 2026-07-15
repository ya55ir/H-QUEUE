class TableType < ApplicationRecord
  belongs_to :venue

  enum status: { available: 0, unavailable: 1 }

  validates :capacity, presence: true, numericality: { greater_than: 0 }
end
