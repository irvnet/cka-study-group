### Building a Test Environment

There are a few considerations for building a test environment to support hands on practice 
* Build  a linux vm quickly and easily on a local laptop
* make it equally easy for Mac, Windows or Linux machines
* ensure the guest OS has access to virtualization support to allow for practice with things like lxd, lxc, docker and such

Either Virtualbox or [Vmware](https://www.vmware.com/) are great choices. For the purpose intended we'll focus on Virtualbox since its cross-platform, stable, and free. There's good [documentation](http://www.virtualbox.org/manual/) for Virtualbox to get a better understanding for the details... and good starter material to help with [install and configure](https://www.virtualbox.org/wiki/User_HOWTOS)

[Vagrant](https://www.vagrantup.com/) is also a good addition since it provides a quick way to test, destroy and redo experiments. It works well in conjunction with Vagrant and its easy to install and [get started](https://www.vagrantup.com/intro/getting-started/index.html). 

For a guest OS on vagrant machines, we'll focus on [Centos](https://www.centos.org/) 7, for consistency, and if there's any need to switch up, we'll handle that when the time comes... 

Here's a short [demo](http://www.youtube.com/watch?v=Erz5tZeG96I) of creating a new proejct with Vagrant




