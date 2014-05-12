# Open Item Sets VagrantFile

This contains the vagrant environment needed to set up the 
development environment.

Once this repository is cloned, please ensure that

```
git submodule update --init
cd openitemsets_web
git pull origin master
```

is ran so the latest version of the OpenItemSets rails project
is downloaded.

To set up the environment, simply cd into the root directory of this repository, and
type
```
vagrant up
```

Once the envrionment is set up, you should be able to access localhost:3000
and see the web application up and running. To start and stop the web application, simply
type ```start/stop thin``` in the command line.

If you are not familiar with Vagrant, please refer to the official
[Vagrant](http://www.vagrantup.com) website.

# LICENSE

Licensed under BSD 2-clause, see LICENSE.
