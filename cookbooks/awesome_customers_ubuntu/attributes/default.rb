default['firewall']['allow_ssh'] = true
default['awesome_customers_ubuntu']['open_ports'] = 80

default['awesome_customers_ubuntu']['user'] = 'web_admin'
default['awesome_customers_ubuntu']['group'] = 'web_admin'
default['awesome_customers_ubuntu']['document_root'] = '/var/www/customers/public_html'
default['awesome_customers_ubuntu']['secret_file'] = '/etc/chef/encrypted_data_bag_secret'
