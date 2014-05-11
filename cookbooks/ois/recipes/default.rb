packages_to_install = [
  "libpq-dev",
  "vim"
]

# install the required packages
packages_to_install.each do |item|
  package item
end
