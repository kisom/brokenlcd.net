.:[ creating an OpenBSD transparent filtering bridge ]:.
========================================================
by kisom <kisom@devio.us> (2010-05-03)
--------------------------------------

0x00 - Introduction
-------------------
A transparent filtering bridge is basically a ethernet bridge connecting two
or more network segments together. A filtering bridge simply silently passes 
traffic between two or more interfaces while applying packet filter rules to 
traffic passing in and out of the interfaces.

What are the advantages to doing this? First, you might want to do some
traffic analysis on your network and your topology (especially in a SOHO
environment) may prohibit this, specifically that you don't have full control
over your modem - you can't install OpenBSD on it. Second, you may only want
to filter on a subset of a segment (say one switch out of multiple switches on 
the same segment). 


0x01 - The Scenario
-------------------
I decided to set up my filtering system between my wireless router and my
DSL modem / gateway at my house. I had a small Compaq desktop machine that
I put three extra NICs in (plus the onboard) to serve as the filter. It had
a blazing fast 864 MHz Pentium III processor with 512M of RAM and a 30G IDE
hard drive.

The NICs I used were:
	fxp0 - onboard Intel 10/100 card
	 rl0 - RealTek 10/100 PCI card
	 dc0 - D-Link 10/100 PCI card
	ath0 - D-Link wireless PCI card

The NICs were assigned roles:
	fxp0 - bridge->gateway
	 rl0 - brige->router
	 dc0 - wired management interface
	ath0 - wireless management interface

Unfortunately, I would later find both dc0 and ath0 were faulty NICs and ended 
up having to resort to serial console.
    

0x02 - Setup
------------
I installed OpenBSD 4.6/i386; the point is to install the latest version of 
OpenBSD with the right architecture. I installed everything except the 
compilers, the man pages, the games and X packages.

Since I was using fxp0 and rl0 as my two bridge interfaces, I created 
/etc/hostname.if files for both interfaces containing simply the command "up":

    # cat /etc/hostname.fxp0
    up
    #

You get the picture.

Then I had to create /etc/bridgename.bridge0 with the following
    add fxp0
    add rl0
    up

When you reboot, the bridge is now up.

For the management interfaces, I created /etc/hostname.if's to grab dhcp
addresses. Unfortunately, as I mentioned earlier both NICs were faulty 
and I ended up not being able to utilize either. One of the advantages to
having a management interface is the ability to test network connectivity
from the machine; this cannot be done otherwise because the bridge interfaces
have no IP address.


0x03 - Next Steps
-----------------
One of the things I learned from the failure of the wireless NIC (which
caused the system to hang) was the use of watchdog(4). To quote the man
page: 
> Hardware watchdog timers are devices that reboot the machine when it
> hangs. The kernel continually resets the watchdog clock on a regular
> basis.  Thus, if the kernel halts, the clock will time out and reset the
> machine.

The watchdog is activated in a system by modifying sysctl parameters, 
specifically, kern.watchdog.auto and kern.watchdog.period. Unfortunately it is
hardware dependent. If your system has watchdog hardware, you may be able to use
it.

I also chose to set my system to use a serial console as I was unable to hook 
up a monitor to the system. This is very simple task: you can choose to do this
during installation (as I did) or by editing /etc/boot.conf:

    # cat /etc/boot.conf
    stty com0 9600
    set tty com0
    #

    # grep tty00 /etc/ttys
    tty00	"/usr/libexec/getty std.9600"	vt220	on secure
    #


0x04 - Filtering
----------------
Standard packet filtering can be applied - use the interface names (as opposed
to the bridge) for rules. Obviously, address based rules will not apply here:
the bridge interfaces have no addresses. The bridge(4) man page presents the   
following advice:
> Bridged packets pass through pf(4) filters once as input on the 
> receiving interface and once as output on all interfaces on which they 
> are forwarded.  In order to pass through the bridge packets must pass 
> any in rules on the input and any out rules on the output interface.  
> Packets may be blocked either entering or leaving the bridge.

The OpenBSD FAQ also notes:
> Keep in mind, by the nature of a bridge, the same data flows through 
> both interfaces, so you only need to filter on one interface.

The man page also has useful information about enabling and disabling STP and 
spanning ports on the bridge. If your site requires these, it is worth 
consulting the man page.

For my network, all I really needed to do was scrub incoming and outgoing 
packets, block everything coming into the router, and modulate state on 
every packet coming out. Basically:

    # cat /etc/pf.conf

    #define bridge0 interfaces
    BRIDGE0_0=fxp0
    BRIDGE0_1=rl0
    
    match in all scrub (random-id)
    match out all scrub (random-id)
    
    block in on $BRIDGE0_0
    pass out on $BRIDGE0_0 modulate state
    
    #

This is a really simple ruleset, you will need to set up a ruleset for your 
organization. This works for a simple SOHO set up where the web server is
colocated in a data center, leaving just workstations that need internet 
access (i.e. no servers needing external access). A router is a much better
choice if you have servers needing external access; the filter is better suited
to filtering certain traffic inside the LAN or providing a span port for 
tcpdump monitoring or an IDS.


0x05 - Resources
The OpenBSD man pages, specifically:
* bridge(4)
* pf.conf(5)
* bridgename.if(5)
* brconfig(8)
[The PF FAQ](http://www.openbsd.org/faq/pf/)
[The OpenBSD FAQ](http://www.openbsd.org/faq/)
Secure Architectures with OpenBSD (written by Brandon Palmer and Jose Nazario,
published by Addison Wesley in 2004)

EOF

