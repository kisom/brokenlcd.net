.:[ the openbsd pf for SOHO users ]:.
author: kisom <kisom@devio.us>



0x00 Introduction
=================

A word of caution: this guide is based on OpenBSD 4.7. 
	*** The pf syntax between previous versions of OpenBSD
	and 4.7 has changed DRASTICALLY in some cases. Therefore,
	besides the fact that it is just a good idea, I HIGHLY
	recommend you use the latest version of OpenBSD on your
	firewall system. ***

OpenBSD is a phenomenal operating system guided by the philosophy of doing
things right, local correctness, stability, and security. 

why use pf? what is pf?


0x01 hardware selection / sample hardware
=========================================

A system running only pf and OpenBSD is a very lean system. The hardware 
required is therefore minimal. The Soekris net4501 is what I am currently 
using as my router / firewall - it features three 10/100 ethernet ports,
a miniPCI and PCI port, a 133 MHz 486 processor, 64M of RAM, and a 4G 
CompactFlash card. You might consider using an older machine with as many
NICs as you need segments - hard drive size is not important, and RAM can be 
in the range of 64M on up (128-256 is a comfortable range for most setups).

Some quick terminology for labeling interfaces is in order. I use the following
terms to describe interfaces:

	RED:	connection to the outside world, aka the link to "the wild."
	GREEN:	connection to the inside network, aka the link to your LAN.
	ORANGE:	connection to machines inside your network that need access
		to the outside world, aka web servers and the like. This is
		commonly referred to as the DMZ.
	BLUE:	connection to a wireless AP LAN - either a single AP plugged
		into here, or connected to a switch that the network of APs
		plugs into.

I will be using my soekris as the reference hardware in this tutorial. I have
a vpn1401 hardware crypto accelerator PCI card and a Intel PRO/Wireless 2200
802.11bg card added into mine, giving me the following network interfaces:

	iwi0:	one of two RED interfaces; one of my network configurations
		requires I pull my WAN connection via wireless. 
	sis0:	GREEN
	sis1:	ORANGE or BLUE
	sis2:	the second of the two RED interfaces.

Before you install OpenBSD on your firewall, you should answer the following
questions:

	1. What does my network architecture look like?
	2. How many users will my firewall be supporting? Is my firewall
	hardware up to the task? Keeping state on a number of connections
	will increase your need for RAM, for example.
	3. For any machines that will be in an ORANGE network, what are their
	MAC addresses and what IP addresses will they have?
	4. Is the firewall machine going to have a monitor and keyboard 
	attached, or will I be using a serial console? (Serial console set up
	in OpenBSD is covered in OpenBSD FAQ 7.6.)

It might be wise to write up the dhcpd.conf that you will be using ahead of
time, or at least plan it out, so that you have any fixed-address hosts set
up.
	

0x02 pfctl and pf.conf
======================

The firewall is written up in /etc/pf.conf, and is controlled using the
program pfctl. As usual, complete documentation may be found in the man
pages; check out pf.conf(5) and pfctl(8). The important flags you will want
to know at first for pfctl are
	-f 	specifies the pf.conf to use
	-e	enable pf
	-d	disable pf
	-n	parse only to check for syntax errors
	-s	show, which uses the following modifiers (I only list a few):
		queue	: shows loaded queue rules
		rules	: shows loaded filter rules
		states	: shows the state tables
		info	: shows filter information, such as stats and counters
		all	: shows all the information pf has to show
	-F	flush, which uses the same modifiers as show


When you run pfctl, you will need to specify which file to use. The rc scripts
are set up to automatically use /etc/pf.conf but any time you manually invoke
pfctl, you will need to specify the file. For example,

pfctl -f /etc/pf.conf

will enable the firewall using /etc/pf.conf (note that the -e is optional),
whereas to disable the firewall,

pfctl -d /etc/pf.conf

One of the things you will want to do often is check your pf.conf for proper
syntax, which you would do with

pfctl -n -f /etc/pf.conf

pf.conf is a simple flat text file read from beginning to end. The last match
for a rule or definition is the match that is used.


0x03 the initialization: macros and options
===========================================

Much like computer languages allow the use of variables, OpenBSD allows the
use of macros. (For those of you who speak perl, s/macros/shell variables/
as they are pretty much eqivalent, except that macros do not change during
runtime.) These are extremely useful in defining the network interfaces:

RED_IF="sis2"
ORANGE_IF="sis1"
GREEN_IF="sis0"

There are some cool ways to use interface macros:
	($RED_IF) 		will use the address of the interface
	$GREEN_IF:network	will use the network attached to the interface
	$RED_IF:broadcast	will use the broadcast address for the network
				attached to the interface

Another use for macros might be to describe specific hosts:

SSH_HOST="192.168.5.1"

Lists are also allowed; a list is specified like such:
"{ value0, value1, value2 }"

Lists may be specified in a macro as well:

ALLOWED_PORTS="{ ssh, dns, http, https }"

All of these macro definitions should be at the top of the file, because they
cannot be used until they have been defined.

After defining the macros, you can specify any runtime options. Runtime options
are set using

set <option> <value>

Some notable options are 

set block-policy <value>
	block:	drop packets
	return:	TCP RST / ICMP Unreachable sent for blocked packets

set loginterface <interface>
	# defines which interface to log packets on

set skip on <interface>
	# packet filtering disabled on <interface>


0x04 scrubbing and normalization
================================

Untouched network traffic can present certain security risks for systems:
outgoing packets may be sniffed for content or information that may be used
to spoof or hijack a session; incoming packets may be malformed causing
problems with clients. Not all of these security problems may be solved by the
firewall, but using packet normalization you can mitigate a lot of problems.
In pf, this is called packet scrubbing, and is set up using the scrub keyword:

match in on $INTERFACE scrub (scrub options)
match out on $INTERFACE scrub (scrub options)

The scrub options I use are
	random-id: randomises the packet's IPID
	reassemble-tcp: "statefully normalises TCP connections"
	no-df: clears the "don't fragment" bit

Applied to the previous statements:

match in on $INTERFACE scrub (reassemble-tcp no-df)
match out on $INTERFACE scrub (random-id no-df reassemble-tcp)

It is a good idea to normalise incoming and outgoing traffic by preventing
fragmented packets (which may be used in an attempt to circumvent the firewall
or as malicious packets) and statefully normalising all TCP connections.
Outgoing packets additionally have their IPIDs randomised to mitigate OS 
profiling by systems sniffing traffic outside the network. Randomising IPIDs
also helps to prevent NAT enumeration, further preventing any information 
about your network leaking out.

Another option is the antispoof directive. To quote from pf.conf(5):
     The antispoof directive expands to a set of filter rules which will block
     all traffic with a source IP from the network(s) directly connected to
     the specified interface(s) from entering the system through any other
     interface.

For example:
antispoof for lo0

This will however interfere with any packets sent over the loopback to
network interfaces. This shouldn't apply on your firewall machine, but
if you run pf on any servers inside the network, you should be aware of this.


0x05 setting up NAT and redirection
===================================

Network Address Translation (NAT) is a useful security mechanism as well as a 
practical means for network connection sharing. In terms of security, it allows 
multiple hosts that do not require public access from the outside world to have
access to the outside world themselves. Using the rdr-to method, certain ports 
may be forwarded to machines inside LAN, allowing Port Address Translation, or
PAT. pf uses the nat-to method for setting up NAT, and the rdr-to method for
PAT.

First, you need to ensure that packet forwarding is set up on your machine. 
Open /etc/sysctl.conf in your favorite text editor (vi, right? RIGHT?) and 
uncomment the line for net.inet.ip.forwarding and/or net.inet6.ip6.forwarding
as required for IPv4 and/or IPv6 packet forwarding respectively. To activate 
packet forwarding immediately, issue a 'sysctl net.inet.ip.forwarding=1' from 
the command line. Obviously, use the appropriate sysctl variables for the 
appropriate IP version.

NAT rules are easy to set up:

match out on $RED_IF from $GREEN_IF:network nat-to ($RED_IF)

This tells pf to match all packets coming out on the RED interface originating
from addresses that orinate inside the GREEN network and translate them to 
the RED interface's address. Any traffic originating from the GREEN network
to the outside world appears to come from the firewall now. 

NAT is a great security tool, but it does have certain weaknesses. By 
examining IPIDs and detecting different sequences, an attack can at a given
time differentiate between hosts. This is where the scrub options come into
play - by randomising IPIDs you can help defeat such an analysis.

To set up a port forward (redirect), you would use a redirect via the rdr-to
method in a pass rule (pass rules will be covered more in the next chapter):

pass in on $RED_IF from any to ($RED_IF) port ssh modulate state \
	$SSH_HOST

The ! keyword is the NOT operator; this rule tells pf that for any packets
coming in on the RED interface that do not originate from the RED interface
and use port ssh (you can use the service names found in /etc/services as 
port names or the actual port number) to redirect them to the host specified
in the SSH_HOST macro. 

The match methods alone will not redirect or translate the packets - pf
requires you also to specify a pass keyword (discussed in the next section)
to actually the pass the packets for the firewall.


0x06 firewall actions - block, pass, log, and quick
===================================================

pf uses two keywords to pass traffic in and out of the firewall - 

	block: use the block policy to reject the specified packets
	pass: allow the specified packets

There are two actions that may be applied to traffic:
	log: log the specified packets using pflog
	quick: skip further processing on the packet and apply the 
	specified action to the traffic.

The first rule should be a default deny for incoming packets:

block in on $RED_IF

This will automatically block packets coming into the firewall. Using the
last-matching behaviour of pf, you now should explicitly tell the firewall
which packets coming in should be allowed.

For a small business or home firewall, you probably want a default allow on
packets coming into and out of the GREEN interface, and a default allow on
packets leaving the RED interface:

pass out on $RED_IF
pass in on $GREEN_IF
pass out on $GREEN_IF

Now you can begin to specify which packets coming into the firewall should be
allowed (if any) and which packets leaving the firewall should be blocked. You
can also set up explicit blocks on traffic on the GREEN interface. For example,
to allow SSH into the firewall (required if you use the afore-mentioned 
redirection example):

pass in on $RED_IF inet from any to ($RED_IF) port ssh

The inet tells the firewall to only allow IPv4 packets in. You can use inet6
to allow IPv6 packets; you may specify both as a list:

pass in on $RED_IF "{ inet, inet6 }" from any to ($RED_IF) port ssh

You can specify the one of the two modifiers after the direction, i.e.

pass in log on $RED_IF inet from any to ($RED_IF) port ssh


0x07 state: keep state and modulate state
=========================================

If you look at the previous rules, you might be curious how traffic is 
supposed to return to clients behind the firewall - for example, a client
browsing an HTML page requires the server to send data back, and the firewall
appears to be blocking all inbound traffic. As it turns out, pf by default
will keep state on traffic, and will use that to allow traffic matching a
session initiated behind the firewall to return back to the firewall.

That may be confusing. What is state? What does it mean when I say that pf
uses stateful inspection? Let's look at a basic TCP connection, initiated by
a client to a web server:

	client					server

	  *--------------- SYN ------------------>
	(the client sends a connection request to the server)

	  <------------ ACK + SYN ---------------*
	(the server sends back an acknowledgement, and sends
	a connection request back to the client. this is how
	TCP sets up a connection-oriented channel.)

	  *--------------- ACK ------------------>
	(the client responds that it is up. the TCP channel is
	now set up.)

This sequence is called the TCP three-way handshake. When pf sees the client
send the initial SYN request, it notes that in a session table. If the server
sends a packet back with SYN and ACK flags on the proper port and destined for
the client, it will allow the packet to pass as it makes the assumption that
this traffic is desired. Once the client sends back the ACK, the firewall will
now permit traffic between the two to pass bidirectionally. The entry in the
session table is called the state. Once the TCP connection is closed, pf
will deny traffic from the server heading back in. The session table also
tracks factors such as the TCP sequence numbers and other information relevant
to determining whether incoming traffic belongs to the current connection. pf
is capable of tracking many connections at once; although, the more connections
it must track, the more the system will be taxed.

If you do not want a rule to create a state entry, you can use the no state
option:

pass out on $RED_IF no state

Another option is to modulate state:

pass out on $RED_IF modulate state

This will create random TCP sequence numbers for each end of the connection. 
Modulating state will only work on TCP connections.

Wait a minute... you thought keeping state only worked on TCP connections
period, right? Well, strictly speaking, you are right. Because UDP is a
connectionless protocol, technically you can't keep state on it. pf works
around this by noting the destination and source IP addresses and the time
that packets are sent and received. After a certain timeout period, the state
is cleared. This is how with the default rules list in the previous section
you can receive ICMP echo replies when you ping out. If you don't believe me,
add the following rule after the 'pass out on $RED_IF' rule:

pass out on $RED_IF inet proto icmp no state

For increased security, it is a good idea to modulate state on TCP connections
where possible.

Another state option is the synproxy option, which will include modulate state.
synproxy state can be used when the firewall is between the two nodes that are
conducting a TCP handshake. It will complete the handshake with the client
(called the active endpoint in the pf documentation), then complete a handshake 
with the server (called the passive endpoint), and finally forward packets i
between the two. This will prevent SYN floods from reaching the server; further,
the synproxy is transparent to both ends. The synproxy state is therefore 
designed to protect a server behind the firewall.

You may pass options to any of the three state methods (keep, module, and 
synproxy state). These options include

	floating: pf will match traffic on any interface, which is the default
	behaviour, and is the opposite of if-bound.

	if-bound: the session will be bound to an interface.

	max (states): specify the maximum number of connections the rule is
	allowed to establish. If the limit is hit, packets will not match this
	rule until an existing session is cleared.

For example, to limit the system to 100 SSH connections:

pass in on $RED_IF proto tcp from any to ($RED_IF) port ssh \
	modulate state (max 100)

The source-track keyword tells pf how to keep track of states per source IP:

	source-track global: tracks states globally
	source-track rule: tracks states per rule

source-track can set the following limits (quoted from pf.conf(5)):

	max-src-nodes number: limits the maximum number of source addresses 
	which can simultaneously have state table entries.

	max-src-states: limits the maximum number of simultaneous state entries
	that a single source address can create with this rule.

All right, so source-track sounds cool, but what is it really used for? This
is actually a powerful option that can limit how many connections a single 
source IP can create at once. You can limit how many different nodes can create
connections (should all of the connections come from one or many addresses?) or
limit how many sessions a single source IP can establish. For example, if you
want to limit a single host from creating more than five sessions to your
webserver:

pass in on $RED_IF proto tcp from any to ($RED_IF) port http \
	modulate state (source-track rule, max-src-states 5)



0x08 tables
===========

Tables are used to hold lists of IP addressed (both IPv4 and IPv6) and are
extremely fast. To quote the PF FAQ:
	"...the lookup time on a table holding 50,000 addresses is only 
	slightly more than for one holding 50 addresses."

You can use tables in filter rules (as either source or destination), and in
translation rules as the translation and/or redirection addresses. 

You specify a table using the table directive:

table <blacklist>  { address1, address2, ..., addressn }

and use them in rules as such:

block in quick on $RED_IF from <blacklist> to ($RED_IF)

You can also modify a table using pfctl:

pfctl -t blacklist -T add 1.2.3.4/8
pfctl -t blacklist -T delete 1.2.3.4/8
pfctl -t blacklist -T show

which adds new entires, deletes entries, and shows the table, respectively.
It is trivial to write a script to scan logfiles and add or delete addresses
based on log files.

Addresses in the tables may be either actual dotted quad / IPv6 numeric
addresses, hostnames, interface names, or the self keyword. Addresses are
matched using the most narrow match - i.e. in the case

table <whitelist> { 10.1.0.0/16, !10.1.19.0/24 }

block in on $RED_IF
pass in on $RED_IF from <blacklist> to any

If the firewall receives traffic from 10.1.19.202, it will be blocked, because
the network 10.1.19.0/24 is a narrower definition than 10.1.0/16; note the use
of the ! operator.


0x09 anchors
============

Anchors are places where rules may be dynamically added and removed - it is for
rules what tables are for addresses. If you used pf before OpenBSD 4.7, you
may be used to having four types of anchors. As of OpenBSD 4.7, the NAT
and redirect syntax changed, converting translation rules to general match
rules. In OpenBSD 4.7's version of pf, there is only one type of anchor rule:

anchor anchor_name

Rules will be loaded into pf.conf at the anchor point. It is important to
remember this, because if rules loaded at the anchor are matched later in the
file, the later rules will govern the fate of the packet. For example, if you
loaded the rule

pass in on $RED_IF from any to ($RED_IF) port ssh

into an anchor, and your pf.conf included

anchor FIREWALL_HOLES
...
block in on $RED_IF from any to ($RED_IF) port ssh 

SSH would still be blocked. This is a very simple rule but it highlights the
need to keep track of what you are passing and blocking through the firewall,
especially in a dynamic rule scenario.

You can load anchor rules using three methods: using a load rule, using 
pfctl, and via an inline rule declaration. 

The load rule tells pf to load rules from the specified file. It looks like:

anchor firewall_holes
load anchor firewall_holes from "/etc/pf/holes.conf"

The file holes.conf should specify valid pf rules that will be loaded into
the firewall in the anchor section. 

Rules may be specified inline as well, to populate an anchor at runtime:

anchor "firewall_holes" {
	# list of rules
}

The last option is to use pfctl to add rules:

pfctl -a firewall_holes -f ${HOME}/pf/firewall_holes.conf
# or
cat ${HOME}/pf/firewall_holes.conf | pfctl -a firewall_holes -f -

 
