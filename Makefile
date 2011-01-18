BASE=${PWD}
SITES="brokenlcd.static"

blcd:
	sw $(BASE)/brokenlcd
	rsync -avz -e "ssh" brokenlcd.static/ kisom@brokenlcd.net:brokenlcd/

clean:
	rm -rf brokenlcd.static
