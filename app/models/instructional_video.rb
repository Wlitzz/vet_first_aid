class InstructionalVideo < ApplicationRecord
  belongs_to :first_aid_procedure, optional: true
  belongs_to :step, optional: true

  validates :title, presence: true
  validates :url, presence: true, format: { with: /\Ahttps?:\/\//i, message: "must start with http:// or https://" }
  validate :must_belong_to_procedure_or_step
  validate :cannot_belong_to_both

  def embed_url
    case url
    when /youtube\.com\/embed\//
      url
    when /youtube\.com\/watch\?v=([^&]+)/
      "https://www.youtube.com/embed/#{$1}"
    when /youtu\.be\/([^?]+)/
      "https://www.youtube.com/embed/#{$1}"
    end
  end

  private

  def must_belong_to_procedure_or_step
    if first_aid_procedure_id.blank? && step_id.blank?
      errors.add(:base, "must be attached to a procedure or a step")
    end
  end

  def cannot_belong_to_both
    if first_aid_procedure_id.present? && step_id.present?
      errors.add(:base, "cannot be attached to both a procedure and a step")
    end
  end
end
