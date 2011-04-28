Factory.define :user do |user|
  user.name                  "Fred Flintstone"
  user.email                 "fred.flintstone@gmail.com"
  user.username              "freddy"
  user.password              "foobar"
  user.password_confirmation "foobar"

  
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
  
end