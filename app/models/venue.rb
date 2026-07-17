class Venue < ApplicationRecord
  has_many :table_types, dependent: :destroy
  has_many :queue_entries, dependent: :destroy

  validates :name, :address, presence: true
  validates :avg_wait_minutes, numericality: { greater_than: 0 }, allow_nil: true

  # Recherche texte sur le nom ou l'adresse
  # Sans query : aucun résultat, l'index n'affiche rien par défaut.
  def self.search(query)
    return none if query.blank?

    # % et _ sont des jokers ILIKE : on échappe ceux tapés par le user pour
    # qu'ils soient cherchés littéralement (sinon "%" matche tous les venues).
    # L'injection SQL, elle, est déjà couverte par :pattern.
    pattern = "%#{sanitize_sql_like(query)}%"
    where("name ILIKE :pattern OR address ILIKE :pattern", pattern: pattern)
      .order(:name)
  end
end
