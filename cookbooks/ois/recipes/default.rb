packages_to_install = [
  "libpq-dev",
  "nodejs",
  "vim"
]

db_user = "vagrant"
db_name = [
  "OpenItemSets_development",
  "OpenItemSets_test"
]

# install the required packages
packages_to_install.each do |item|
  package item
end

execute "bundle install" do
  cwd "/vagrant/openitemsets_web"
end

execute "create-database-user" do
    code = <<-EOH
    psql -U postgres -c "select * from pg_user where usename='#{db_user}'" | grep -c #{db_user}
    EOH
    command "createuser -U postgres -sw #{db_user}"
    not_if code 
end
 
 
db_to_create.each do |db_name|
  execute "create-database" do
      exists = <<-EOH
      psql -U postgres -c "select * from pg_database WHERE datname='#{db_name}'" | grep -c #{db_name}
      EOH
      command "createdb -U postgres -O #{db_user} -E utf8 -T template0 #{db_name}"
      not_if exists
  end
end
