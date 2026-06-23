class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :isbn, null: false
      t.string :description
      t.integer :total_copies, null: false
      t.integer :available_copies, null: false
      t.datetime :published_at, null: false

      t.timestamps
    end
    add_index :books, :isbn, unique: true
  end
end
