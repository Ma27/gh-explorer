{ pkgs ? (import <nixpkgs>) {} }:

{
  backend = import ./backend.nix { };
  frontend = import ./frontend {
    inherit pkgs;
  };
}
