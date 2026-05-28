class CreateQuizQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_questions do |t|
      t.string :prompt
      t.json :options
      t.string :correct_answer
      t.references :quiz, null: false, foreign_key: true
      t.references :first_aid_procedure, null: false, foreign_key: true

      t.timestamps
    end
  end
end
