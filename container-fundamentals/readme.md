
# Understanding Container Fundamentals

**What's the practical difference between vm's and containers?**  
* *Hypervisors emulate hardware... containers isolate processes*. 
* The hypervisor emulates hardware.. which gives the user the freedom to install a full copy of any operating system as a guest on the hypervisor, which allows a windows machine running Virtualbox to install a linux guest. 
* Containers provide isolation for user space instances on the same linux kernel. The isolation allows processes to have access to a subset of reources (memory, storaage, etc) in a more lightweight fashion than hypervisors.

#### lxc / lxd
https://linuxcontainers.org/

#### docker
https://www.docker.com/

#### Understanding the importance of user space & kernel space for containers
https://unix.stackexchange.com/questions/87625/what-is-difference-between-user-space-and-kernel-space  
http://rhelblog.redhat.com/2015/07/29/architecting-containers-part-1-user-space-vs-kernel-space/  
https://www.usna.edu/Users/cs/aviv/classes/ic221/s16/lec/11/lec.html  

#### Understanding isolation with linux control groups 
https://www.digitalocean.com/community/tutorials/how-to-limit-resources-using-cgroups-on-centos-6  
https://linuxaria.com/article/introduction-to-cgroups-the-linux-conrol-group  
https://www.kernel.org/doc/Documentation/cgroup-v1/cgroups.txt  
https://0xax.gitbooks.io/linux-insides/content/Cgroups/cgroups1.html  

#### Understanding the difference between application containers vs system containers (and when to use one or the other)
https://blog.risingstack.com/operating-system-containers-vs-application-containers/  
https://containerjournal.com/2016/07/25/system-containers-vs-application-containers-difference-matter/  
https://containerjournal.com/2016/12/06/use-system-containers-instead-docker-app-containers/   


