require 'machinist/active_record'

Sham.email 		{ Faker::Internet.email }
Sham.name 		{ Faker::Name.name }
Sham.domain 		{ Faker::Internet.domain_name }

User.blueprint do
	email               { Sham.email }
	encrypted_password  { Sham.name }
  password_salt       { Sham.name }
end

Domain.blueprint do
	domain              { Sham.domain }
	folder              { Sham.name }
end

