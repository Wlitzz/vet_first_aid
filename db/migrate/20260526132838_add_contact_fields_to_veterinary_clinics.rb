class AddContactFieldsToVeterinaryClinics < ActiveRecord::Migration[8.1]
  def change
    add_column :veterinary_clinics, :email, :string
    add_column :veterinary_clinics, :website, :string
  end
end
