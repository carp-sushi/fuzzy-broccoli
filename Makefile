.PHONY: all
all: format compile

.PHONY: format
format:
	mix format

.PHONY: compile
compile:
	mix compile --warnings-as-errors --all-warnings

.PHONY: test
test:
	mix test --trace --cover

.PHONY: clean
clean:
	mix clean

.PHONY: migrate
migrate:
	mix migrate

.PHONY: run
run:
	iex -S mix

.PHONY: release-testnet
release-testnet:
	NETWORK_PREFIX=tp MIX_ENV=prod mix release

.PHONY: release
release:
	MIX_ENV=prod mix release
