require 'machinist/active_record'

Sham.email 		{ Faker::Internet.email }
Sham.password { User::generate_password }

Sham.domain   { Faker::Internet.domain_name }

User.blueprint do
	email
	password
end

Domain.blueprint do
	domain  
	folder    { Sham.name }
end
