# cx

[![Package Version](https://img.shields.io/hexpm/v/cx)](https://hex.pm/packages/cx)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/cx/)

A library, written in Gleam, to help create and read (contextual) objects of varying structures and types

## Installing
```sh
gleam add cx
```

## Usage

```gleam
import cx

pub fn main() {
  let context =
    cx.dict()
    |> cx.add(
      "settings",
      cx.dict()
        |> cx.add_string("theme", "dark")
        |> cx.add_strings("themes", ["light", "dark"]),
    )
    |> cx.add_list("people", [
      cx.add_strings(cx.dict(), "Nicknames", ["Jane", "Jill"]),
    ])


    // Result: Ok(["light", "dark"])
    cx.get_strings(context, "settings.themes")
}
```

Further documentation can be found at <https://hexdocs.pm/cx>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
