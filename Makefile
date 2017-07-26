default: build

lint:
	$(MAKE) -C backend/ lint

backend:
	$(MAKE) -C backend/ watch

frontend:
	nix-shell -p elmPackages.elm \
		--run "pushd frontend; elm-reactor; popd;"

build:
	nix-build .

migrate:
	nix-shell -p sqlite --run "sqlite3 backend/ghex.db < backend/schema/sqlite.sql"

.PHONY: backend frontend
