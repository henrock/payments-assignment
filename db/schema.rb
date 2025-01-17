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

ActiveRecord::Schema.define(version: 2022_10_06_213104) do

  create_table "municipalities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "municipality_prices", force: :cascade do |t|
    t.integer "price_cents", default: 0, null: false
    t.integer "municipality_id", null: false
    t.integer "package_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["municipality_id"], name: "index_municipality_prices_on_municipality_id"
    t.index ["package_id"], name: "index_municipality_prices_on_package_id"
  end

  create_table "packages", force: :cascade do |t|
    t.integer "price_cents", default: 0, null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_packages_on_name", unique: true
  end

  create_table "prices", force: :cascade do |t|
    t.integer "price_cents", null: false
    t.integer "package_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "municipality_id"
    t.index ["municipality_id"], name: "index_prices_on_municipality_id"
    t.index ["package_id"], name: "index_prices_on_package_id"
  end

  add_foreign_key "municipality_prices", "municipalities"
  add_foreign_key "municipality_prices", "packages"
  add_foreign_key "prices", "packages"
end
