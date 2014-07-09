# config/initializers/redis.rb
config = YAML.load_file(Rails.root + 'config/redis.yml')
$redis = Redis.new(:host => config[Rails.env]["host"], :port => config[Rails.env]["port"], db: config[Rails.env]["db"])
