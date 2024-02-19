# print this menu
default:
    @just --list

# format source tree
fmt:
    treefmt

# run REPL (cabal)
repl *ARGS:
    cabal repl {{ARGS}}

# run ghcid (auto-recompile and run `main` function)
run:
    ghcid -c "cabal repl exe:kell" --warnings -T :main

# run hoogle
docs:
    printf 'http://127.0.0.1:8888\n'
    hoogle serve -p 8888 --local
