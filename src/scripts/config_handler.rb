if File.exists?("config.yaml")
    CONFIG = YAML.load_file 'config.yaml'
end

if CONFIG == ''
    raise MissingConfig.new
end

vagrant_name = CONFIG['vagrant_name']
vagrant_ip = CONFIG['vagrant_ip']
vagrant_port = CONFIG['vagrant_port']
db_user = CONFIG['db_user']
db_password = CONFIG['db_password']
ssh_username = CONFIG['ssh_username']
folder = CONFIG['folder']
php_version = CONFIG['php_version']

if vagrant_name.nil? || vagrant_name.empty?
    raise MissingConfiguration.new '"vagrant_name"'
end

if vagrant_ip.nil? || vagrant_ip.empty?
    raise MissingConfiguration.new '"vagrant_ip"'
end

if vagrant_port.nil?
    raise MissingConfiguration.new '"vagrant_port"'
end

if db_user.nil? || db_user.empty?
    raise MissingConfiguration.new '"db_user"'
end

if db_password.nil? || db_password.empty?
    raise MissingConfiguration.new '"db_password"'
end

if ssh_username.nil? || ssh_username.empty?
    raise MissingConfiguration.new '"ssh_username"'
end

if folder.nil? || folder.empty?
    raise MissingConfiguration.new '"folder"'
end
