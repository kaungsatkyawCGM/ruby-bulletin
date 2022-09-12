class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, unique: true
      t.string :email, null: false, unique: true
      t.text "password_digest", null: false
      t.string :role, limit: 1
      t.string :phone
      t.integer :created_by, null: true
      t.bigint :updated_by, null: true
      t.integer :deleted_by
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
