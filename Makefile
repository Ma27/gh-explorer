lint:
	nix-shell -p hlint --run "hlint ."

watch:
	nix-shell -p stack --run "stack build --nix --file-watch --exec gh-explorer"

build:
	nix-shell -p stack --run "stack build --nix"

shell:
	nix-shell -p stack

migrate:
	nix-shell -p sqlite --run "sqlite3 ghex.db < schema/sqlite.sql"
