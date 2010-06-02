require 'yaml'

config = YAML.load_file("#{RAILS_ROOT}/config/gccp.yml")
VHOST_TARGET_DIR = config["config"]["vhost_target_dir"]
WWW_DIR = config["config"]["www_dir"]

