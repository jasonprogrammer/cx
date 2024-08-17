# cx

[![Package Version](https://img.shields.io/hexpm/v/cx)](https://hex.pm/packages/cx)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/cx/)

A library, written in [Gleam](https://gleam.run/), to help create data
structures containing different data types and levels of nesting.

**Note**: This library is still being written!

## Background

Gleam is statically typed, and has certain restrictions for certain data types.
For example, a [Dict](https://hexdocs.pm/gleam_stdlib/gleam/dict.html) in Gleam
has this restriction on the keys and values:

```
...all the keys must be of the same type and all the values must be of the same type.
```

[Lists](https://hexdocs.pm/gleam_stdlib/gleam/list.html) have a similar restriction:

```
All elements of a list must be the same type
```

What if we want to represent more complicated, nested data structures as well?
For example, here is a native data structure in Python:

```python3
data = {
    "settings": {
        "theme": "dark",
        "themes: ["light", "dark"]
    }
    "people": [
        {"Nicknames": ["Jane", "Jill"]},
    ]
}
```

Can we do this in Gleam? Yes, we can, with
[records](https://tour.gleam.run/data-types/records/).
Records can also help us know the type of each object stored in the data
structure, which is significant because runtime reflection is not available in
Gleam.

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
