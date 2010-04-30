require 'machinist/active_record'

Sham.email 		{ Faker::Internet.email }
Sham.password { User::generate_password }
Sham.name 		{ Faker::Name.name }
Sham.domain   { Faker::Internet.domain_name }

User.blueprint do
	email
	password
end

Domain.blueprint do
	domain  
  user_id   { 1 }
end

Database.blueprint do
	name
  user_id   { 1 }
end
