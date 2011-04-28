
raw_config = File.read(Rails.root.join('config','config.yml'))
APP_CONFIG = YAML.load(raw_config)[Rails.env]
