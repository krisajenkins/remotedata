all: tests.js

tests.js: FORCE $(shell find src -type f -name '*.elm' -o -name '*.js')
	elm-make --yes --warn
	./node_modules/.bin/elm-test

FORCE:
