DESTDIR=/usr/local
MANPATH=$(DESTDIR)/share/man

all: manpage

install: all
	cp convmv.1.gz $(MANPATH)/man1/
	install -m 755 convmv $(DESTDIR)/bin/

manpage:
	pod2man --section 1 --center=" " convmv | gzip > convmv.1.gz

clean:
	rm -f convmv.1.gz convmv-*.tar.gz MD5sums

dist: clean
	sed -n "2,2p" convmv |sed "s/.*convmv \([^ ]*\).*/\1/" > VERSION
	md5sum `find . -name "*" -type f` |gpg --clearsign >.MD5sums
	mv .MD5sums MD5sums
	ls > .files
	echo convmv-`cat VERSION` >.name
	mkdir `cat .name`
	mv `cat .files` `cat .name`
	tar --posix -cv * |gzip > `cat .name`.tar.gz
	mv `cat .name`/* .
	rmdir `cat .name`
