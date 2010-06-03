require 'yaml'
config = YAML.load_file("#{RAILS_ROOT}/config/gccp.yml")

# create first admin
User.create(
  :username => config["firstadmin"]["username"],
  :email => config["firstadmin"]["email"],
  :password => config["firstadmin"]["password"],
  :admin => true
)
