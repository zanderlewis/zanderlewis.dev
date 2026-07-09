.PHONY: install build serve dev deploy clean runner-init runner-up runner-down runner-logs

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
	cd .runner && docker compose up -d

runner-down:
	cd .runner && docker compose down

runner-logs:
	cd .runner && docker compose logs -f runner

binary:
	shards build
	./bin/capsule build

clean:
	rm -rf public bin lib .shards
