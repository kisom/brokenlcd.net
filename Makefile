SITE=brokenlcd

# ensure RHOST has a trailing slash!
#     e.g. foo@spam:baz/
RHOST=kisom@brokenlcd.net:brokenlcd/
BASE=$(PWD)

all:	site-gen site-push

site-gen:
	@time sw $(BASE)/$(SITE)

site-push:
	rsync -auvz -e "ssh" $(SITE).static/ $(RHOST)

clean:
	rm -rf $(SITE).static


.PHONY: all clean site-gen

