GITHUB_API_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/github_api.yml")).result)[Rails.env].symbolize_keys
