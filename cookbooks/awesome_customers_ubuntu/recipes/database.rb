#
# Cookbook Name:: awesome_customers_ubuntu
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

mysql2_chef_gem 'default' do  
  action :install
end

# Configure the mysql client.
mysql_client 'default' do
  action :create
end

# Load the secrets file and the encrypted data bag item that holds the root password.
password_secret = Chef::EncryptedDataBagItem.load_secret(node['awesome_customers_ubuntu']['secret_file'])
password_data_bag_item = Chef::EncryptedDataBagItem.load('database_passwords', 'mysql_customers', password_secret)

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password password_data_bag_item['root_password']
  action [:create, :start]
end
