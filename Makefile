.PHONY: install build serve dev deploy clean

install:
	shards install

build:
	shards run -- build

serve:
	shards run -- serve

dev: build serve

deploy:
	./scripts/deploy.sh

binary:
	shards build
	./bin/capsule build

clean:
	rm -rf public bin lib .shards
