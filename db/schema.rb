# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_26_172014) do
  create_table "books", force: :cascade do |t|
    t.integer "available_copies", null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "isbn", null: false
    t.datetime "published_at", null: false
    t.string "title", null: false
    t.integer "total_copies", null: false
    t.datetime "updated_at", null: false
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
  end

  create_table "loans", force: :cascade do |t|
    t.integer "book_id", null: false
    t.datetime "borrowed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "due_date", null: false
    t.datetime "returned_at"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["book_id"], name: "index_loans_on_book_id"
    t.index ["user_id"], name: "index_loans_on_user_id"
  end

# Could not dump table "sqlite_stat1" because of following StandardError
#   Unknown type '' for column 'idx'


# Could not dump table "sqlite_stat4" because of following StandardError
#   Unknown type '' for column 'idx'


  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "loans", "books"
  add_foreign_key "loans", "users"
end
