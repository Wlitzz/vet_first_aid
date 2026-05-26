class CreateInstructionalVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :instructional_videos do |t|
      t.references :first_aid_procedure, null: true, foreign_key: true
      t.references :step, null: true, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false
      t.text :description

      t.timestamps
    end
  end
end
