class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.bigint :user_id
      t.integer :amount
      t.text :note
      t.bigint :tags_id, array: true
      t.datetime :happened_at
      t.datetime :deleted_at
      t.integer :kind, null: false

      t.timestamps
    end
  end
end
