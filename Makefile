.PHONY: install build serve dev clean

install:
	shards install

build:
	shards run -- build

serve:
	shards run -- serve

dev: build serve

binary:
	shards build
	./bin/capsule build

clean:
	rm -rf public bin lib .shards
