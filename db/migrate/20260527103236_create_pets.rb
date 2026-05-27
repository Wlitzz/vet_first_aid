class CreatePets < ActiveRecord::Migration[8.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :species
      t.string :breed
      t.date :date_of_birth
      t.decimal :weight
      t.text :allergies
      t.text :medical_notes

      t.timestamps
    end
  end
end
