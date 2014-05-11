# First we have to copy the private key

cookbook_file "id_rsa" do
  path "/home/vagrant/.ssh/id_rsa"
  action :create_if_missing
end
