class Step < ApplicationRecord
  belongs_to :first_aid_procedure
  has_many :instructional_videos, dependent: :destroy

  validates :instruction, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }
  validates :position, uniqueness: { scope: :first_aid_procedure_id, message: "already taken for this procedure" }

  def checklist_items
    return [] if checklist.blank?
    checklist.split("\n").map(&:strip).reject(&:blank?)
  end
end
