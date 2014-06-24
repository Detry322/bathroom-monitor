SECRET = (YAML.load_file( File.join(Rails.root, 'config', 'access_key.yml') ))['secret_key']
