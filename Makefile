CC=g++
CPPFLAGS=
CFLAGS=-g -Wall
CXXFLAGS=-g -Wall
LDFLAGS=-g -Wall

export CC
export CPPFLAGS
export CFLAGS
export CXXFLAGS
export LDFLAGS

# directories
srcdir=src
bindir=bin

all:
	cd $(srcdir) && $(MAKE) $@
	cp $(srcdir)/notegrind $(bindir)/notegrind

clean:
	cd $(srcdir) && $(MAKE) $@
	-rm bin/*

check:
	cd $(srcdir) && $(MAKE) $@