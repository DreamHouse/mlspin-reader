APP_CONFIG = YAML::load(ERB.new(IO.read("#{Rails.root}/../local/mlspin_reader/config.yml")).result)[Rails.env]
