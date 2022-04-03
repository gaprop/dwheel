.POSIX:

all: dwheel

dhweel: ghc -dynamic Main.hs -o dhweel

install: dwheel
	mkdir -p $(DESTDIR)/bin
	cp -f dhweel $(DESTDIR)/bin

