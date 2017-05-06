Setup a quick virtual machine environment for Ruby on Rails application development. 

## Table of Contents
 - [Overview](#overview)
 - [What's Included](#whats-included)
 - [Prerequisites](#prerequisites)
 - [Building the Virtual Machine](#building)
	- [Initial Setup](#initial-setup)
	- [Usage](#usage)
		- [Setup VM Inside an Existing Rails Project](#option-1)
		- [Set up as a Standalone VM](#option-2)
			- [Create a New Rails Project](#option-2a)
			- [Run an Existing Rails Project](#option-2b)
 - [Suggested Workflow](#workflow)
	- [Virtual Machine Managements](#virtual-machine-management)
 - [Troubleshooting](#troubleshooting)
	 - [Port Collision](#port-collision)
	 - [Box Not Found](#box-not-found)
	 - [Page Not Found](#page-not-found)
	 - [SSH Binary Not Found](#ssh-binary-not-found)

<a name="overview"></a>
## Overview
It looks like there's a lot in this readme, but really, the steps are:
* Clone this repo (5 sec)
* vagrant up (5 sec)
* Go read an xkcd comic or two while vagrant initially sets up the VM (2 min)
* Get your ruby on

<a name="whats-included"></a>
## What's Included
* Ubuntu 14.04 Trust Tahr 64-bit 
* Ruby 2.2.2 
* Ruby on Rails (through Bundler)
* SQLite3
	* MySQL (optional, see bootstrap)
	* PostgreSQL (optional, see bootstrap)
* Node.js

<a name="prerequisites"></a>
## Prerequisites
* [VirtualBox](https://www.virtualbox.org) - Get the latest version, you no use old versions from package manager repositories!
* [Vagrant](http://vagrantup.com) - Same as above. Version 1.5.x or later is required for this box to boot 
* [Git Bash](https://msysgit.github.io/) or [Git Extensions](https://code.google.com/p/gitextensions/) (optional)

Vagrant requires VirtualBox. Git Bash/Extensions is optional, and only needed by Windows users to run the below linux-based commands and interact with the VM

<a name="building"></a>
## Building the Virtual Machine
<a href="initial-setup"></a>
### Initial Setup
```sh
$ git clone https://github.com/bill-c-martin/rails-app-dev-box.git
$ cd rails-app-dev-box
$ vagrant up
```
<a name="usage"></a>
### Usage
There are two options for setting up the virtual machine. 
* Inside of an existing rails project
* Outside as a stand-alone box to create rails projects inside of

<a name="option-1"></a>
#### Option 1) Setup VM Inside an Existing Rails Project
Copy the Vagrantfile and bootstrap from this repo to your project directory and boot the VM:
```sh
$ cp {bootstrap.sh,VagrantFile} /path/to/your/existing/rails/project/
$ cd /path/to/your/existing/rails/project
$ vagrant up
```
Login to the box and install dependencies for your rails project:
```sh
$ vagrant ssh
$ cd /vagrant/ 
$ bundle
```

Perform any database creation & migrations and start the web server:
```sh
$ bundle exec rake db:create db:migrate db:seed
$ rails server
```	
<a name="option-2"></a>
#### Option 2) Setup as a Standalone VM

Simply boot & provision the machine:
```sh
$ vagrant up
```

Now at this point, you can either create a new rails project, or copy over an existing one.

<a name="option-2a"></a>
##### Create a New Rails Project

Login to the box & install rails:
```sh
$ vagrant ssh
$ cd /vagrant/
$ sudo gem install rails
```

Exit and log back into the box so the rails commands work (You will get rails command not found otherwise):
```sh
$ exit
$ vagrant ssh
$ cd /vagrant/
```

And now create a new project and start the web server:
```sh
$ rails new yourproject
$ rails server
```	

<a name="option-2b"></a>
##### Run an Existing Rails Project

To setup an existing project, copy in the project directory, and install dependencies for the project, and launch the web server
```sh
$ cp /path/to/your/project/ your-project-name
$ vagrant ssh
$ cd /vagrant/
$ bundle
```

And now perform any database creation & migrations and start the web server:
```sh
$ bundle exec rake db:create db:migrate db:seed
$ rails server
```	

<a name="#workflow"></a>
## Suggested Workflow
* Login to the VM box ($ vagrant ssh)
* Enter your project's directory ($ /vagrant/your-project-name)
* Start the rails web server ($ rails server) inside of your project 
* Edit your project's files on your (host) computer, with your editor of choice, such as Sublime or IDE such as Rubymine
* Realize that vagrant keeps your changes synced to the /vagrant/your-project-name/ inside the VM
* Maintain your repository with git on your (host) computer
* Basically do everything you would normally do on your (host) computer
* Run your rails app at [http://localhost:3000](localhost:3000) in your local browser on your host machine since your guest (VM) is forwarding port 3000
* Shut off the VM when you're done as problems can sometimes occur when your host computer shuts off while the VM continues on running

<a name="virtual-machine-management"></a>
#### Virtual Machine Management

##### To Stop the Web Server & Shutdown the VM
```sh
$ (hit ctrl-c to end the web server)
$ exit
$ vagrant halt
```

##### To Resume the Web Server & VM again
```sh
$ vagrant up
$ vagrant ssh
$ cd /vagrant/your-project-name
$ rails server
```

##### To Find Out if VM is Running
```sh
$ vagrant status
```

<a name="#troubleshooting"></a>
## Troubleshooting
<a name="#port-collision"></a>
### Port Collision
>"Vagrant cannot forward the specified ports on this VM, since they would collide with another VirtualBox virtual machine's forwarded ports! The forwarded port to 4567 is already in use on the host machine."

If you get an error about the host's 3000 port already being taken while doing $ vagrant up, kill all VirtualBox processes first. Sometimes your previous vagrant attempts will have VMs still running, holding onto port 3000. You can also open VirtualBox and see if any VMs are running, and end them. 

If this fails, and something on your host machine is listening to 3000 already, change the host: xxxx port in Vagrantfile to something else unique.

<a name="#box-not-found"></a>
### Box Not Found
>"The box 'ubuntu/trusty64' could not be found"

This error is caused by not using the latest version of Vagrant. Somewhere around version 1.5.x, Vagrant started supporting the shorthand box syntax where a URL does not need to be predefined in Vagrantfile. Verify that you are using version 1.7.4 or later with:
```sh
$ vagrant -v
```

If you are using Linux and used a package manager like apt-get to install vagrant, those repositories tend to have older versions of vagrant. Skip the package manager entirely, and go directly to the [vagrant site](https://www.vagrantup.com/) to download the latest version.

<a name="page-not-found"></a>
### Page Not Found

> Page Not Found (in Browser)

This is when you're not able to pull up your rails app in your browser. You forgot to start the web server, the virtual machine, or both.

```sh
$ vagrant up
$ vagrant ssh
$ rails server
```

<a name="#ssh-binary-not-found"></a>
### SSH Binary Not Found
>$ vagrant ssh
>`ssh` binary could not be found. Is an SSH client installed?

This can happen on certain types of minimal Linux systems that don't ship with an ssh client by default, such as on Arch Linux. The solution is to install one, such as Open SSH. In the case of Arch:
>$ sudo pacman -S openssh
