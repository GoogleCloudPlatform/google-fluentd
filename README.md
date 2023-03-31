# About

[![Build Status](https://travis-ci.org/treasure-data/omnibus-td-agent.svg)](https://travis-ci.org/treasure-data/omnibus-td-agent)

The event collector daemon, for Treasure Data. This daemon collects various types of logs/events via various way, and transfer them to the cloud. For more about Treasure Data, see the [homepage](http://treasuredata.com/), and the [documentation](http://docs.treasuredata.com/).

td-agent is open sourced as [Fluentd project](http://github.com/fluent/). In other words, td-agent is a distribution package of Fluentd.

td-agent package is based on [Omnibus-ruby](https://github.com/opscode/omnibus-ruby)

## Installation

We'll assume you have Ruby 2.7 and Bundler installed. First ensure all required gems are installed and ready to use:

```shell
$ bundle install --binstubs
```

## Usage

### Build

At first, you should download dependent gems using downloder. This is for avoding broken gem download and reduce the build time by avoiding internet access.

```shell
$ bin/gem_downloader core_gems.rb
$ bin/gem_downloader plugin_gems.rb
$ bin/gem_downloader ui_gems.rb
```

Create required directory and add permission

```shell
$ sudo mkdir -p /opt/td-agent /var/cache/omnibus
$ sudo chown [USER] /opt/td-agent
$ sudo chown [USER] /var/cache/omnibus
```

After that, you create a platform-specific package using the `build project` command:

```shell
$ bin/omnibus build td-agent2
```

The platform/architecture type of the package created will match the platform
where the `build project` command is invoked. So running this command on say a
MacBook Pro will generate a Mac OS X specific package. After the build
completes packages will be available in `pkg/`.

#### Build on CentOS 5

td-agent build doesn't work on CentOS 5 by OpenSSL related issues.
Follow this setup instruction before use omnibus: https://gist.github.com/repeatedly/97d4746e83a5ec135abf3eb77f46ff30

### Clean

You can clean up all temporary files generated during the build process with
the `clean` command:

```shell
$ bin/omnibus clean
```

Adding the `--purge` purge option removes __ALL__ files generated during the
build including the project install directory (`/opt/td-agent`) and
the package cache directory (`/var/cache/omnibus/pkg`):

```shell
$ bin/omnibus clean --purge
```

### Help

Full help for the Omnibus command line interface can be accessed with the
`help` command:

```shell
$ bin/omnibus help
```

### Build with customized plugins, files and package name

Follow steps below to build packages with customized gem lists, configuration files and original package name.

1. make plugin list for your own environment
  * add `your_plugin_gems.rb` to define the plugin list for your package
  * `rm plugin_gems/*`
  * `bin/gem_downloader your_plugin_gems.rb`
2. make your default configuration file
  * edit `templates/etc/td-agent/td-agent.conf` and `td-agent.conf.tmpl`
3. copy `config/projects/td-agent2.rb` to `config/projects/YOUR_PACKAGE_NAME.rb`
4. edit `config/projects/YOUR_PACKAGE_NAME.rb`
  * fix `name`, `maintainer`, `homepage` and `description`
  * change `install_dir` as `/opt/YOUR_PACKAGE_NAME`
  * change `build_version` and `build_iteration`
  * comment out `td` and `td-agent-ui` if you want not to install them
5. build package by `bin/omnibus build YOUR_PACKAGE_NAME`
6. test your package file

Build script generates file paths with `YOUR_PACKAGE_NAME`, from templates. Leave file names with `td-agent` in `templates`.

NOTE: edit `project_name` in Vagrantfile if required.

## Vagrant-based Virtualized Build Lab

td-agent omnibus ships will a project-specific [Berksfile](http://berkshelf.com/) and [Vagrantfile](http://www.vagrantup.com/)
that will allow you to build your projects on the following platforms:

* CentOS 6 64-bit
* CentOS 6 32-bit
* CentOS 7 64-bit
* Ubuntu 12.04 64-bit
* Ubuntu 12.04 32-bit
* Ubuntu 14.04 64-bit
* Ubuntu 16.04 64-bit
* Debian 7.10 64-bit
* Debian 8.4 64-bit
* Amazon Linux 2016.03 64-bit

Please note this build-lab is only meant to get you up and running quickly;
there's nothing inherent in Omnibus that restricts you to just building CentOS
or Ubuntu packages. See the Vagrantfile to add new platforms to your build lab.

The only requirements for standing up this virtualized build lab are:

* VirtualBox - native packages exist for most platforms and can be downloaded
from the [VirtualBox downloads page](https://www.virtualbox.org/wiki/Downloads).
* Vagrant 1.2.1+ - native packages exist for most platforms and can be downloaded
from the [Vagrant downloads page](https://www.vagrantup.com/downloads.html).

The [vagrant-berkshelf](https://github.com/RiotGames/vagrant-berkshelf) and
[vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus) Vagrant plugins
are also required and can be installed easily with the following commands:

```shell
$ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-omnibus
$ vagrant plugin install vagrant-vbguest
```

Exceute `berks` command to setup cookbooks

```shell
$ berks vendor cookbooks
```

Once the pre-requisites are installed you can build your package across all
platforms with the following command:

```shell
$ vagrant up
```

If you would like to build a package for a single platform the command looks like this:

```shell
$ vagrant up PLATFORM
```

The complete list of valid platform names can be viewed with the `vagrant status` command.

### Amazon Linux build

You need to install vagrant-aws 0.5.0 and add `--provider` option to `vagrant up`.

```sh
AWS_SSH_KEY_PATH=/path/to/your_aws_key_file vagrant up amazon --provider=aws
```

After build package, you need to copy rpm file from ec2 instances. No automatic sync for now.

### pkg_build command

You can build all environments via `bin/pkg_build` command.

```sh
./bin/pkg_build
```

After that, each package is stored in `td_agent2_pkg` directory.

```sh
% ls td_agent2_pkg/
centos-6.7/   centos-7.2/   debian-7.10/  debian-8.4/   ubuntu-12.04/ ubuntu-14.04/ ubuntu-16.04/
```

### Tested environment

```sh
% vagrant --version
Vagrant 1.7.4

% VBoxHeadless --version
Oracle VM VirtualBox Headless Interface 5.0.4
(C) 2008-2015 Oracle Corporation
All rights reserved.

5.0.4r102546

% ruby --version
ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin15]
```

### NOTE

Vagrant syncs current directory in each platform. Downloaded gems are also installed automatically.

And you should not use `rbenv local` in project root because Ruby environment is built on top of rbenv in Vagrant.
So if you set different Ruby verion in `.ruby-version`, running ruby code will fail during pacakging process. 

## Kitchen-based Build Environment

Every Omnibus project ships will a project-specific
[Berksfile](http://berkshelf.com/) and [Vagrantfile](http://www.vagrantup.com/)
that will allow you to build your omnibus projects on all of the projects listed
in the `.kitchen.yml`. You can add/remove additional platforms as needed by
changing the list found in the `.kitchen.yml` `platforms` YAML stanza.

This build environment is designed to get you up-and-running quickly. However,
there is nothing that restricts you to building on other platforms. Simply use
the [omnibus cookbook](https://github.com/opscode-cookbooks/omnibus) to setup
your desired platform and execute the build steps listed above.

The default build environment requires Test Kitchen and VirtualBox for local
development. Test Kitchen also exposes the ability to provision instances using
various cloud providers like AWS, DigitalOcean, or OpenStack. For more
information, please see the [Test Kitchen documentation](http://kitchen.ci).

Once you have tweaked your `.kitchen.yml` (or `.kitchen.local.yml`) to your
liking, you can bring up an individual build environment using the `kitchen`
command.

```shell
$ bundle exec kitchen converge default-ubuntu-1204
```

Then login to the instance and build the project as described in the Usage
section:

```shell
$ bundle exec kitchen login default-ubuntu-1204
[vagrant@ubuntu...] $ cd td-agent
[vagrant@ubuntu...] $ bundle install
[vagrant@ubuntu...] $ ...
[vagrant@ubuntu...] $ ./bin/omnibus build td-agent2
```

For a complete list of all commands and platforms, run `kitchen list` or
`kitchen help`.

# License

Treasure Agent package is released under the Apache2 license.
