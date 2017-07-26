default: build

lint:
	$(MAKE) -C backend/ lint

watch:
	$(MAKE) -C backend/ watch

build:
	nix-build .

migrate:
	nix-shell -p sqlite --run "sqlite3 backend/ghex.db < backend/schema/sqlite.sql"
