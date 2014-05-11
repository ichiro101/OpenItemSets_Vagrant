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
  execute "create-database" do
      exists = <<-EOH
      sudo -u postgres psql -U postgres -c "select * from pg_database WHERE datname='#{db_name}'" | grep -c #{db_name}
      EOH
      command "sudo -u postgres createdb -U postgres -O #{db_user} -E utf8 -l en_US.UTF8 -T template0 #{db_name}"
      not_if exists
  end
end

script 'Bundling the gems' do
  interpreter 'bash'
  cwd current_release_directory
  code <<-EOS
    bundle install
  EOS
end
