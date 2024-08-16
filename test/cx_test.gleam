import cx
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn context_test() {
  let themes = ["light", "dark"]

  let context =
    cx.dict()
    |> cx.add(
      "settings",
      cx.dict()
        |> cx.add_string("theme", "dark")
        |> cx.add_strings("themes", themes),
    )
    |> cx.add_list("people", [
      cx.add_strings(cx.dict(), "Nicknames", ["Jane", "Jill"]),
    ])

  cx.get_strings(context, "settings.themes")
  |> should.equal(Ok(themes))
}
