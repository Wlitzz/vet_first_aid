class FirstAidProcedure < ApplicationRecord
  SPECIES = %w[dog cat rabbit hamster].freeze
  SEVERITIES = %w[immediate consult_vet_soon].freeze

  has_many :steps, -> { order(:position) }, dependent: :destroy
  has_many :instructional_videos, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :symptom_keywords, presence: true
  validates :species, inclusion: { in: SPECIES, message: "must be dog, cat, rabbit, or hamster" }
  validates :severity, inclusion: { in: SEVERITIES, message: "must be immediate or consult_vet_soon" }

  scope :by_species, ->(s) { where(species: s) if s.present? }
  scope :search, lambda { |q|
    where(
      "name LIKE ? OR description LIKE ? OR symptom_keywords LIKE ?",
      "%#{q}%", "%#{q}%", "%#{q}%"
    ) if q.present?
  }

  def severity_label
    severity == "immediate" ? "Immediate Action Required" : "Consult Vet Soon"
  end

  def severity_color
    severity == "immediate" ? "red" : "yellow"
  end
end
