class Venue < ApplicationRecord
  has_many :table_types, dependent: :destroy
  has_many :queue_entries, dependent: :destroy

  geocoded_by :address # active near / distance sur les colonnes latitude & longitude
  NEARBY_RADIUS_KM = 1 # distance de recherche par défaut

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

  def current_queue_count
    queue_entries.where(status: :waiting).count
  end

  # Recherche générique des venues autour d'une position (latitude, longitude) dans une distance de NEARBY_RADIUS_KM.
  def self.nearby(latitude, longitude)
    near([latitude, longitude], NEARBY_RADIUS_KM, units: :km)
  end

  # Recherche des venues autour d'un venue donné, ce venue étant exclu des résultats.
  def self.nearby_of(venue)
    nearby(venue.latitude, venue.longitude).excluding(venue)
  end
end
