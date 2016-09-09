all: tests.js

tests.js: FORCE
	elm-make Main.elm --yes --warn --output=$@
	@node $@

FORCE:
