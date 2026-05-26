class CreateFirstAidProcedures < ActiveRecord::Migration[8.1]
  def change
    create_table :first_aid_procedures do |t|
      t.string :name
      t.string :species
      t.string :severity
      t.text :symptom_keywords
      t.text :description

      t.timestamps
    end
  end
end
