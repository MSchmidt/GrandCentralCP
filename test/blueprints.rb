require 'machinist/active_record'

Sham.email 		{ Faker::Internet.free_email }
Sham.password { User::generate_password }
Sham.username 		{ Faker::Internet.user_name[0..15]}
Sham.fqdn     { Faker::Internet.domain_name }

User.blueprint do
  username
	email
	password
end

Domain.blueprint do
	fqdn  
  user_id     { 1 }
  mount_point { Sham.username }
end

Database.blueprint do
	name      { Sham.username }
  user_id   { 1 }
end
