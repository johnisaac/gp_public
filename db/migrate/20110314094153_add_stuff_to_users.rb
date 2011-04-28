class AddStuffToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :bio, :string
    add_column :users, :avatar, :string
  end

  def self.down
    remove_column :users, :avatar
    remove_column :users, :bio
    remove_column :users, :username
    remove_column :users, :name
  end
end
