class CreateMusics < ActiveRecord::Migration[6.0]
  def change
    create_table :musics do |t|
      t.string :name
      t.integer :analyzed_status, default: 1
      t.text :comment
      t.string :title
      t.integer :track
      t.integer :year
      t.references :album, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true

      t.timestamps
    end
    add_index :musics, :title
  end
end
