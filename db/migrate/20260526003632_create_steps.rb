class CreateSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :steps do |t|
      t.references :first_aid_procedure, null: false, foreign_key: true
      t.integer :position, null: false
      t.text :instruction, null: false
      t.text :checklist

      t.timestamps
    end

    add_index :steps, [:first_aid_procedure_id, :position], unique: true
  end
end
