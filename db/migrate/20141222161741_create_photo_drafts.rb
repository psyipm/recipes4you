class CreatePhotoDrafts < ActiveRecord::Migration
  def change
    create_table :photo_drafts do |t|
      t.string :src
      t.string :src_big
      t.integer :post_id

      t.timestamps
    end
  end
end
