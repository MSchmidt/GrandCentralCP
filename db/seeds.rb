require 'yaml'

config = YAML.load_file("#{RAILS_ROOT}/config/gccp.yml")
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
User.create(:name => config["firstadmin"]["name"], :email => config["firstadmin"]["email"], :password => config["firstadmin"]["password"], :admin => true)
