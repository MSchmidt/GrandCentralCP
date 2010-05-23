require 'machinist/active_record'

Sham.email 		{ Faker::Internet.free_email }
Sham.password { User::generate_password }
Sham.name 		{ Faker::Internet.user_name[0..15]}
Sham.fqdn     { Faker::Internet.domain_name }

User.blueprint do
  name
	email
	password
end

Domain.blueprint do
	fqdn  
  user_id     { 1 }
  mount_point { Sham.name }
end

Database.blueprint do
	name
  user_id   { 1 }
end
