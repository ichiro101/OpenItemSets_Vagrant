packages_to_install = [
  "libpq-dev",
  "nodejs",
  "vim"
]

db_user = "vagrant"
db_to_create = [
  "OpenItemSets_development",
  "OpenItemSets_test"
]

current_release_directory = "/vagrant/openitemsets_web"

# install the required packages
packages_to_install.each do |item|
  package item
end

execute "create-database-user" do
  code = <<-EOH
  sudo -u postgres psql -U postgres -c "select * from pg_user where usename='#{db_user}'" | grep -c #{db_user}
  EOH
  command "sudo -u postgres createuser -U postgres -sw #{db_user}"
  not_if code 
end
 
 
db_to_create.each do |db_name|
  execute "create-database #{db_name}" do
    exists = <<-EOH
    sudo -u postgres psql -U postgres -c "select * from pg_database WHERE datname='#{db_name}'" | grep -c #{db_name}
    EOH
    command "sudo -u postgres createdb -U postgres -O #{db_user} -E utf8 -l en_US.UTF8 -T template0 #{db_name}"
    not_if exists
  end
end

rvm_shell "bundle install" do
  ruby_string "2.1.2"
  user        "root"
  cwd         current_release_directory
  code        %{bundle install}
end

rvm_shell "run db setup on development db" do
  ruby_string "2.1.2"
  user        "vagrant"
  cwd         current_release_directory
  code        %{bundle exec rake db:setup}
end

rvm_shell "run db setup on test db" do
  ruby_string "2.1.2"
  user        "vagrant"
  cwd         current_release_directory
  code        %{bundle exec rake db:setup RAILS_ENV=test}
end

template "/etc/init/thin.conf" do
  source "thin.conf.erb"
  variables(
    {
      :app_directory => current_release_directory,
      :port => 3000,
      :environment => "development"
    }
  )
  action :create
end

template "/etc/init/redmon.conf" do
  source "redmon.conf.erb"
  action :create
end

rvm_gem "thin" do
  ruby_string "2.1.2"
  action :install
end

rvm_gem "redmon" do
  ruby_string "2.1.2"
  action :install
end

rvm_wrapper "sys" do
  ruby_string "2.1.2"
  binary "thin"
end

rvm_wrapper "sys" do
  ruby_string "2.1.2"
  binary "redmon"
end

service "thin" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

service "redmon" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
