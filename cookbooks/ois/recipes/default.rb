packages_to_install = [
  "libpq-dev",
  "vim"
]

# First we have to copy the private key
cookbook_file "id_rsa" do
  path "/home/vagrant/.ssh/id_rsa"
  owner "vagrant"
  group "vagrant"
  action :create_if_missing
end


# install the required packages
package packages_to_install

# we need this gem to run bundle on our rails repo
gem "bundler"

# now clone the OpenItemSets web repository
git "/home/vagrant/ois_web" do
  repository "git@github.com:ichiro101/openitemsets_web.git"
  user "vagrant"
  action :checkout
end
