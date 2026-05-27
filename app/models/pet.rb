class Pet < ApplicationRecord
  belongs_to :pet_owner

  validates :name, :species, presence: true
end