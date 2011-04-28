class AddStuffToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :item_name, :string
    add_column :posts, :a_name, :string
    add_column :posts, :a_twitter, :string
    add_column :posts, :g_from, :string
    add_column :posts, :image, :string
  end

  def self.down
    remove_column :posts, :image
    remove_column :posts, :g_from
    remove_column :posts, :a_twitter
    remove_column :posts, :a_name
    remove_column :posts, :item_name
  end
end
