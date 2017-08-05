default: build

lint:
	$(MAKE) -C backend/ lint

backend:
	$(MAKE) -C backend/ watch

frontend:
	nix-shell -p elmPackages.elm \
		--run "$(MAKE) reactor"

build:
	nix-build .

migrate:
	nix-shell -p sqlite --run "sqlite3 backend/ghex.db < backend/schema/sqlite.sql"

reactor:
	(cd frontend && elm-reactor)

.PHONY: backend frontend
