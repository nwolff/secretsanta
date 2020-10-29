Deployed automatically to:

https://nwolff.github.io/secretsanta/

---

Requires elm0.19.1

To develop:

    elm reactor

Or if you've installed elm-live:

    elm-live src/Main.elm --open -- --output target/elm.js --debug

To build:

    elm make src/Main.elm --output target/elm.js

Deployed automatically upon push to main:

Using https://github.com/isaacvando/elm-to-gh-pages
