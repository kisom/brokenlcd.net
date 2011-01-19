# site-tools Makefile to build and push a site built using smu and sw.
# usage: edit SITE and RHOST
# 	- Kyle Isom <coder@kyleisom.net>

# directory containing site source
SITE=brokenlcd

# ensure RHOST has a trailing slash!
#     e.g. foo@spam:baz/
RHOST=kisom@brokenlcd.net:brokenlcd/

# don't touch - we need this for sw to work properly
BASE="$(PWD)"


### shouldn't need to modify anything below these lines ###

all:	site

site:
	sw $(BASE)/$(SITE)

install: 
	rsync -auvz -e "ssh" $(SITE).static/ $(RHOST)

clean:
	rm -rf $(SITE).static

target-list:
	@echo "valid targets:"
	@echo "	site:  	 build site and push it "
	@echo " install: rsync site to RHOST"
	@echo " clean:   remove \$(SITE).static"
	@echo " "


.PHONY: all clean site-gen

