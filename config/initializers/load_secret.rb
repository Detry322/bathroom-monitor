SECRET = YAML.load_file(File.join(Rails.root, 'config', 'shared_secret.yml'))['secret']
