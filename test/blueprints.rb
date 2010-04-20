require 'machinist/active_record'

Sham.email 		{ Faker::Internet.email }
Sham.name 		{ Faker::Name.name }
Sham.domain   { Faker::Internet.domain_name }

User.blueprint do
	email
	password   { Sham.name }
end

Domain.blueprint do
	domain  
	folder    { Sham.name }
end

