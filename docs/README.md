# Boilerplate for ANTLR4

You can use this template to make your DSL (Domain-Specific Languages) using [ANTLR4][antlr].

In this template, you can use the Makefile to execute commands:

| Command        | Description                              |
|----------------|------------------------------------------|
| `make antlr`   | Run ANTLR.                               |
| `make compile` | Compile files in some cases (like Java). |
| `make grun`    | Run the Parse Tree Inspector.            |

You can find a copy of this document in the [`docs`](docs) folder.

## Getting Started

To start your DSL you must run:

```shell
make init
```

You must fill in the data or accept the default values, as in the example below:

```text
--- Project ---
Title ["Title here"]: My first DSL
Description ["Description here"]: A DSL to make "Hello World"

--- Code Generation Target ---
Target language ["Java"]: Python3

--- Grammar ---
The name of your grammar ["Expr"]: HelloWorld

Generating README.md
Done! (README.md)
Generating Makefile
Done! (Makefile)
Generating src/HelloWorld.g4
Done! (src/HelloWorld.g4)
```

[antlr]: https://www.antlr.org/
