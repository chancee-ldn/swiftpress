title: Installing Swift on CentOS 7.1
date: 27/08/2016
excerpt: Swift, on a server. Fuck yes.
tags: Swift, CentOS, Web, Server
lang: English
link: 

Excuse the ugly formatting. After some trial and error and some XKCD level StackOverflow hunting you can run Swift fairly ok on CentOS, posting it here because I couldn't find the whole process anywhere else 😳 

Presuming a brand new and clean install of CentOS, start from the top - if your up and running and have sudo, start from the second section., some basic adding a user, updating yum and installing dependancies, then pulling a copy of Swift and running it.

Lots of help from [here](http://www.swiftprogrammer.info/swift_centos_1.html) and [here](https://github.com/apple/swift/blob/master/README.md).

	bash
	## ADD A USER AND ADD TO SUDO
	adduser <user name>
	passwd <user name>

	gpasswd -a <user name> wheel

	## AMEND sshd_config to disable root login
	vi /etc/ssh/sshd_config
	PermitRootLogin no
	systemctl reload sshd

	## Bring up firewall
	sudo systemctl start firewalld
	sudo firewall-cmd --permanent --add-service=ssh
	sudo firewall-cmd --permanent --add-service=http

	#list available services
	sudo firewall-cmd --get-services

	#list services to be used
	sudo firewall-cmd --permanent --list-all

	#implement changes
	sudo firewall-cmd --reload

	#switch the firewall on
	sudo systemctl enable firewalld


	# set time
	sudo timedatectl set-timezone Europe/London
	sudo yum install ntp
	#install ntp (keeps server time in sync)
	sudo systemctl start ntpd
	sudo systemctl enable ntpd

	#
	# Switch to your new user and try out your sudo privilages
	#
	sudo yum makecache fast
	sudo yum update
	sudo yum install yum-utils


	# install svn and some requirements for gcc
	# i didn't need to end up doing this...so safely ignore?
	#sudo yum install svn texinfo-tex flex zip libgcc.i686 glibc-devel.i686


	#########	SECOND SECTION
	#########	INSTALLING SWIFT (the development version worked better than the release)
	#########

	## getting some dependancies
	sudo yum install epel-release
	sudo yum install libbsd-devel
	sudo yum group install "Development Tools"

	# install some dev tools
	sudo yum install git clang libstdc++ gcc 

	# grabbing an updated repo
	# (https://www.rpmfind.net/linux/rpm2html/search.php?query=libicuuc.so.52()(64bit)) grabbed from here, Swift needed the updated version
	wget ftp://195.220.108.108/linux/sourceforge/r/ra/ramonelinux/Rel_0.98/releases/x86_64/packages/icu-52.1-1.ram0.98.x86_64.rpm
	sudo rpm -Uvh icu-52.1-1.ram0.98.x86_64.rpm

	sudo ln -s /lib64/libedit.so.0 /lib64/libedit.so.2
	sudo ln -s /usr/lib64/libicui18n.so /usr/lib64/libicui18n.so.52
	sudo ln -s /usr/lib64/libicuuc.so /usr/lib64/libicuuc.so.52

	# the swift bit
	wget https://swift.org/builds/development/ubuntu1404/swift-DEVELOPMENT-SNAPSHOT-2016-08-26-a/swift-DEVELOPMENT-SNAPSHOT-2016-08-26-a-ubuntu14.04.tar.gz
	tar xsf swift-DEVELOPMENT-SNAPSHOT-2016-08-26-a-ubuntu14.04.tar.gz
	mv swift-DEVELOPMENT-SNAPSHOT-2016-08-26-a-ubuntu14.04 swift-3
	#clean up
	rm -rf icu-52.1-1.ram0.98.x86_64.rpm 	swift-DEVELOPMENT-SNAPSHOT-2016-08-26-a-ubuntu14.04.tar.gz


	## Presuming you unzipped swift to your home directory
	## Add to path
	export PATH=/home/<user name>/swift-3/usr/bin:"${PATH}"

```
