import cx
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn get_string_test() {
  let first_name = "Jane"
  let key = "first_name"

  let context =
    cx.dict()
    |> cx.add_string(key, first_name)
  cx.get_string(context, key)
  |> should.equal(Ok(first_name))
}

pub fn get_string_nested_test() {
  let first_name = "Jane"

  let context =
    cx.dict()
    |> cx.add(
      "person",
      cx.dict()
        |> cx.add_string("first_name", first_name),
    )
  cx.get_string(context, "person.first_name")
  |> should.equal(Ok(first_name))
}

pub fn get_strings_test() {
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

pub fn get_bool_test() {
  let context =
    cx.dict()
    |> cx.add_bool("is_active", True)
    |> cx.add_string("non_empty", "abc")
    |> cx.add_string("empty", "")
    |> cx.add_int("non_zero_int", 1)
    |> cx.add_int("zero_int", 0)
    |> cx.add_float("non_zero_float", 1.0)
    |> cx.add_float("zero_float", 0.0)
  cx.get_bool(context, "is_active")
  |> should.equal(Ok(True))

  cx.get_bool(context, "non_empty")
  |> should.equal(Ok(True))

  cx.get_bool(context, "empty")
  |> should.equal(Ok(False))

  cx.get_bool(context, "non_zero_int")
  |> should.equal(Ok(True))

  cx.get_bool(context, "zero_int")
  |> should.equal(Ok(False))

  cx.get_bool(context, "non_zero_float")
  |> should.equal(Ok(True))

  cx.get_bool(context, "zero_float")
  |> should.equal(Ok(False))
}
