#require 'faker'

#namespace :db do
#  desc "Fill database with sample data"
#  task :populate => :environment do
#    Rake::Task['db:reset'].invoke
#    admin = User.create!(:name => "Example User",
#                        
#                       :email => "example@railstutorial.org",
#                      :password => "foobar",
#                         :password_confirmation => "foobar")
#
#  99.times do |n|
#    name  = Faker::Name.name
#     email = "example-#{n+1}@railstutorial.org"
#    password  = "password"
#     User.create!(:name => name,
#                  
#                  :email => email,
#                 :password => password,
#                  :password_confirmation => password)
#                  
#end
#
#
#  User.all(:limit => 6).each do |user|
#    50.times do
#    user.posts.create!(:content => "The model and scaffold generators will create migrations appropriate for adding a new model. This migration will already contain instructions for creating the relevant table. If you tell Rails what columns you want then statements for adding those will also be created. For example, running", 
#                              :title => "Hey I just bought omar rodriguez lopez's new album!",
#                              :item_name => "Agua Dulce De Pulpo",
#                              :a_name => "Omar Rodriguez Lopez",
#                              :a_twitter => "@ORLProductions",
#                              :g_from => "Hello Merch")
#                              
#   end
#  end
# end
#end
