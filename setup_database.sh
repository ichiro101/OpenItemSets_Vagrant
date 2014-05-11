sudo -u postgres createuser vagrant -s
sudo -u postgres createdb OpenItemSets_development -O vagrant
sudo -u postgres createdb OpenItemSets_test -O vagrant
