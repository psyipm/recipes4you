class CreatePostDrafts < ActiveRecord::Migration
  def change
    create_table :post_drafts do |t|
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
