class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table(:posts, primary_key: 'post_id') do |t|
      t.column :title, :string, limit: 255
      t.column :description, :string, limit: 255
      t.column :image_data, :text
      t.boolean :public_flag, default: 1
      t.references :created_user, foreign_key: { to_table: :users }, on_delete: :cascade
      t.references :updated_user, foreign_key: { to_table: :users }, on_delete: :cascade
      t.timestamps
    end
  end
end
