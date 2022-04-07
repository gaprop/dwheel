.POSIX:

HC=ghc
FLAGS= -dynamic -no-keep-hi-files -no-keep-o-files
DESTDIR=/usr/local/bin
DATADIR=${XDG_DATA_HOME}/dwheel
CACHEDIR=${XDG_CACHE_HOME}/dwheel

# all: dwheel

dwheel-check: Main.hs
	$(HC) $(FLAGS) Main.hs -o dwheel-check

$(DESTDIR):
	sudo mkdir -p $@

$(DATADIR):
	mkdir -p $@

$(CACHEDIR):
	mkdir -p $@

install: dwheel-check tables $(DESTDIR) $(DATADIR) $(CACHEDIR)
	sudo cp -f dwheel-check $(DESTDIR)
	sudo cp -f dwheel $(DESTDIR)
	cp -r ./tables/* $(DATADIR)
