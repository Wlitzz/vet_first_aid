class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes do |t|
      t.string :title
      t.string :description
      t.string :icon
      t.string :topic_key

      t.timestamps
    end
  end
end
