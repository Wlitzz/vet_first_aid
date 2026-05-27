class PetOwner < ApplicationRecord
  belongs_to :account
  has_many :pets, dependent: :destroy
end