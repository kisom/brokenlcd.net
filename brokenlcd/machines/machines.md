dev machines or how i get things done
=====================================

at one point in my life, i had a rack of servers and networking gear
in my living room. this was pretty cool from a hacker standpoint, but
not really for anything else. although, having 1000base-sx running
everywhere was pretty nice...

i've been moving to a point in my life where i'm trying to condense
hardware. i'm down to the following:


ono-sendai
----------
a lenovo thinkpad t410 that is my primary development machine.
* ubuntu server, heavily stripped down and running awesome
* 2.6 ghz i5 
* 4gb ram
* 64gb internal ssd
* 512gb sata in the drivebay


gibson
------
a 2010 aluminum mac mini. it serves as a multimedia machine as well as
housing multiple development virtual machines, including sterling, stross,
and molly.
* os x 10.whatever
* 2.4 ghz c2d
* 8gb ram
* 320gb internal drive
* 2tb external data drive
* 2tb external backup drive


straylight
----------
2009 13" macbook pro, this is my laptop i know will just work.   
* os x 10.7
* 2.0 ghz c2d
* 8gb ram
* 120gb internal ssd


shadow
------
soekris net4501 running openbsd-4.8/i386 currently serving as my lan 
firewall / router. i handwrote the firewall rules - pf is a wonderful
firewalling system. forwards ssh to shiva and silc to kali.
* 133 mhz 486
* 64mb ram
* 4gb cf card
* vpn1401 hardware cryptographic accelerator

the following machines are inactive right while i am out of the country:

neil
----
sun ultra/5 running openbsd-4.7/sparc64. this machine is a beast in terms
of uptime, so much so that it's easy to forget about. it does dns, dhcp,
and tftp (i.e. for setting up the sheevas).
* 233 mhz ultrasparc-IIi
* 256mb ram
* 20gb hard drive


shiva
-----
globalscale industries' sheeva plug. this is the primary ssh host inside
the lan. it is a development machine.
* 1.4ghz marvell arm cpu
* 512m ram
* 4g sd card rootfs (aes256-encrypted)


kali
----
another sheeva plug computer. lan tor / squid proxy and general purpose
development machine. 
* 1.4ghz marvell arm cpu
* 512m ram
* 4g sd card rootfs (aes256-encrypted)


virtual machines
----------------
* sterling: ubuntu 10.10 i386 linux development vm
* molly: openbsd 4.8/amd64 dev vm
* stross: openbsd 4.8/i386 dev vm

