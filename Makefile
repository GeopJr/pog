.PHONY: all install uninstall test build debug static
PREFIX ?= /usr

all: build

debug:
	shards build

build:
	shards build --production --release --no-debug
	
static:
	shards build --production --release --no-debug --static

test:
	POG_ENABLE_DEEPSEARCH=false crystal spec --order random
	POG_ENABLE_DEEPSEARCH=true crystal spec --order random

install:
	install -D -m 0755 bin/pog $(PREFIX)/bin/pog

uninstall:
	rm -f $(PREFIX)/bin/pog
