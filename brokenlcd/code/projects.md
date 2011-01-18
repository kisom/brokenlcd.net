current projects
================

surfraw
-------
* [homepage](http://surfraw.alioth.debian.org)
* i've written several elvi:
1. duckduckgo - i rewrote ianb's version of the duckduckgo elvi to
include multiple improvements: defaulting to ssl search, javascript
toggle, and control over other parameters; also includes improvements
when used in text mode. confirmed for 2.2.8.
2. openports - there is an openbsd elvi that includes a rudimentary
[openports.se](http://www.openports.se) search; i wrote a dedicated
openports elvi that allows for searching based on every parameter allowed
by the site. confirmed for 2.2.8.
3. cablesearch - this is an unprecedented elvi (in that its functionality 
isn't based or included at all in any other elvi) that searches for leaked
diplomatic cables. ianb noted that as julian assange was the original
author of surfraw, this was only appropriate. i wrote this on behalf of
msowers, who asked me to include it while i was adding the other two elvi.
confirmed for 2.2.8. ianb also kept my "mischievous comment" in the local
options. i guess i should take credit / blame for any panicky emails...
4. stackoverflow - searches stack overflow, includes options to search by
tags and ask a question, among other options. this has not been confirmed
for inclusion in any version yet.


pymusiclib
----------
* [github page](https://github.com/kisom/pymusiclib)
* python tools to handle music libraries. currently supported are:
0. dedup.py - handles tag-based (and optionally hash-based, defaulting
to the python-crypto md5 module)
0. AudioFile - python class that includes a generic audio file metadata
class supporting easier comparison between types of audio. including
a magic file function to automatically handle a given file. currently
supports mp3 and aac (mp4) audio files; flac support shouldn't be 
too hard to add later on. also includes a number of tools to assist
in comparing two audio files, including a select option that, given
two AudioFile instances, returns the filename of the file that should
be removed (but can be easily adapted to return the higher quality
of the two).
* in progress:
    * orglib.py - tag-based music library organisation. currently a blank
    file in the repository, mostly to remind me to actually do something
    with it.

itun
----
* [github page](https://github.com/kisom/itun)
* perl-based simplified iodine tunnel setup. currently only the client-side
code is done.
* confirmed working on openbsd
* doesn't appear to work on linux; more testing / debugging is required


login-fuzzer
------------
* [github page](https://github.com/kisom/Login-Fuzzer)
* python script to bruteforce / fuzz logins
* interface / engine pairing:
0. interfaces are an interface to a login system, i.e. ssh. written is
are an echo interface (for debugging / testing) and a python-paramiko
interface for ssh logins.
0. engines are password generating engines, i.e. bruteforce and fuzzing.
* i wrote this because i locked myself out of one of my plug computers,
which happened to not have a serial interface. even after a week of
running this, i hadn't gotten in and sprung for a jtag adapter. i felt
that by having written this, i had done enough penance.
* the code would benefit greatly from threading or multiprocessing; i 
haven't gotten around to that yet.


build\_release
--------------
* [github page](https://github.com/kisom/build_release)
* perl script to build custom openbsd install isos based on a siteXX.tgz
file (see man 8 release in the openbsd documentation).
* works with intel architectures (i386 / amd64)
* sparc support is planned, i need to learn how to get mkisofs to properly
insert the sparc bootloader.


woofs
-----
* [github page](https://github.com/kisom/woofs)
* python script duplicating the functionality of simon budig's woof script
* operates over https instead of http
* in progress


inactive projects
=================

apod_py
-------
* [github page](https://github.com/kisom/APOD_py)
* python script to fetch the latest nasa astronomy picture of the day
* includes option to set the wallpaper in a couple of *nix window 
managers and desktop environments as well as in os x.
* trafficone worked on a win32 background setting code, which has yet to
be merged into the main repo.
* the code is finished and has been working without error for a while 
(i use it on my work machine to update the wallpaper every night at
22h15).


pyphone
-------
* [github page](https://github.com/kisom/PyPhone)
* python code written in an attempt to make a python-based softphone
* interfaces with google voice (using pygooglevoice)
* includes Qt4 sms-sending code
* abstract phone and sms classes
* development halted when i realised the shortcomings of googlevoice and
skype; namely, calls require either the skype software to be running or
to bounce through a cell phone. the project was designed to be run from
a beagleboard, so this ended up being an unworkable solution.


sfe-mp3
-------
* [github page](https://github.com/brokenlcd/Custom-MP3-Board-Code)
* [sparkfun mp3 board](http://www.sparkfun.com/commerce/product_info.php?products_id=8603)
* my custom code for the sparkfun mp3 player.
* the code sucks and temporarily bricked the mp3 player until i can dig
up my jtag adapter.
* i also made minor revisions to the original sparkfun code, stored in
[this github repo](https://github.com/kisom/sfe_mp3)


other code
----------
other non-public software i have worked on includes:

* dropsonde, a python social intelligence / data mining system that
gave some interesting results. it does rudimentary stock analysis, 
identifies interesting news items, and builds its social network. it 
uses twitter for data collection and was my first foray into natural
language processing and data mining.

* various wargames code i've accumulated

* the [devio.us](http://devio.us) admin scripts that run and maintain 
the devio.us shell server, which as of early 2011 had over 5,000 users.
it was interesting to see the approach taken by zeeby and jjpickle; one of
my projects in university was to build a public netbsd shell server (which
due to network constraints was never brought online). my shell user
management system actually got me an offer from google.

* a bastard operator from hell toolkit, which offered some ingenius 
(or so i thought) menu options. it listed a number of common problems
(such as user needs more space) and implemented a number of bofh-worthy
solutions (remove all the user's files to give them more space). sadly,
this has been lost to the sands of time as it was before i started using
version control systems.

* v2os was an x86 assembly operating system written from scratch. i did 
some work on the tcp stack in high school. unfortunately, out of privacy
concerns, i worked on it under an pseudonym and i don't think i ever 
actually submitted my code. nonetheless, it gave me valuable insights into
tcp/ip networking.



