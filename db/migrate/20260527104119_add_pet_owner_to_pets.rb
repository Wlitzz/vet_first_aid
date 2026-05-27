class AddPetOwnerToPets < ActiveRecord::Migration[8.1]
  def change
    add_reference :pets, :pet_owner, null: false, foreign_key: true
  end
end
