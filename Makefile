.POSIX:

HC=ghc
FLAGS= -dynamic -no-keep-hi-files -no-keep-o-files
DESTDIR=lul
DATADIR=lul/local/share
CACHEDIR=lul/cache

# all: dwheel

dwheel-check: Main.hs
	$(HC) $(FLAGS) Main.hs -o dwheel-check

$(DESTDIR)/bin:
	mkdir -p $@

$(DATADIR)/dwheel:
	mkdir -p $@

$(CACHEDIR)/dwheel:
	mkdir -p $@

install: dwheel-check $(DESTDIR)/bin $(DATADIR)/dwheel $(CACHEDIR)/dwheel
	cp -f dwheel-check $(DESTDIR)/bin
	cp -f dwheel $(DESTDIR)/bin
	cp -r ./tables/* $(DATADIR)/dwheel
