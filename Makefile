.PHONY: install build serve dev deploy clean runner-init runner-up runner-down runner-logs runner-rm

install:
	shards install

build:
	shards run -- build

serve:
	shards run -- serve

dev: build serve

deploy:
	./scripts/deploy.sh

runner-init:
	./scripts/runner/init.sh

runner-up:
	./scripts/runner/up.sh

runner-down:
	./scripts/runner/down.sh

runner-logs:
	./scripts/runner/logs.sh

runner-rm:
	./scripts/runner/rm.sh

binary:
	shards build
	./bin/capsule build

clean:
	rm -rf public bin lib .shards
