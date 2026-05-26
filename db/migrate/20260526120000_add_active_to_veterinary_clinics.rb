class AddActiveToVeterinaryClinics < ActiveRecord::Migration[7.1]
  def change
    add_column :veterinary_clinics, :active, :boolean, null: false, default: true
    add_index  :veterinary_clinics, :active
  end
end
