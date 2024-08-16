import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string

pub type Context {
  CString(value: String)
  CInt(value: Int)
  CFloat(value: Float)
  CDict(value: Dict(String, Context))
  CList(value: List(Context))
}

pub type ContextError {
  KeyNotFound(key: String)
  ValueNotFound(key: String)
  UnexpectedContextType(key: String)
}

pub fn dict() -> Context {
  CDict(dict.new())
}

pub fn add_int(context: Context, key: String, value: Int) -> Context {
  case context {
    CDict(d) -> CDict(dict.insert(d, key, CInt(value)))
    _ -> context
  }
}

pub fn add_float(context: Context, key: String, value: Float) -> Context {
  case context {
    CDict(d) -> CDict(dict.insert(d, key, CFloat(value)))
    _ -> context
  }
}

pub fn add_string(context: Context, key: String, value: String) -> Context {
  case context {
    CDict(d) -> CDict(dict.insert(d, key, CString(value)))
    _ -> context
  }
}

pub fn get(context: Context, key: String) -> Result(Context, ContextError) {
  case context {
    CDict(d) ->
      case dict.get(d, key) {
        Ok(v) -> Ok(v)
        _ -> Error(KeyNotFound(key))
      }
    _ -> Error(UnexpectedContextType(key))
  }
}

fn get_list_final(
  context: Context,
  key: String,
) -> Result(List(Context), ContextError) {
  case context {
    CDict(d) -> {
      case dict.get(d, key) {
        Ok(value) -> {
          case value {
            CList(l) -> Ok(l)
            _ -> Error(UnexpectedContextType(key))
          }
        }
        _ -> Error(KeyNotFound(key))
      }
    }
    _ -> Error(ValueNotFound(key))
  }
}

pub fn get_list(
  context: Context,
  key: String,
) -> Result(List(Context), ContextError) {
  case string.split(key, on: ".") {
    [key1] -> get_list_final(context, key1)
    [key1, key2, ..] -> {
      case get(context, key1) {
        Ok(dict1) -> get_list(dict1, key2)
        Error(_) -> Error(ValueNotFound(key1))
      }
    }
    [] -> Error(ValueNotFound(key))
  }
}

/// Returns a list of strings using the "final" part of the key under which the
/// string values are stored. For example, if the key is: "settings.themes",
/// then the "final" key would be "themes".
fn get_strings_final(
  context: Context,
  key: String,
) -> Result(List(String), ContextError) {
  case get_list(context, key) {
    Ok(items) -> {
      Ok(
        list.filter_map(items, fn(item) {
          case item {
            CString(s) -> Ok(s)
            _ -> Error(UnexpectedContextType(key))
          }
        })
      )
    }
    Error(_) -> Error(ValueNotFound(key))
  }
}

/// Get a list of strings stored in the context under a given key.
pub fn get_strings(
  context: Context,
  key: String,
) -> Result(List(String), ContextError) {
  case string.split(key, on: ".") {
    [key1] -> get_strings_final(context, key1)
    [key1, key2, ..] -> {
      case get(context, key1) {
        Ok(dict1) -> get_strings(dict1, key2)
        Error(_) -> Error(ValueNotFound(key1))
      }
    }
    [] -> Error(ValueNotFound(key))
  }
}

/// Return a string using the "final" part of the key under which the string
/// values are stored. For example, if the key is: "settings.theme", then the
/// "final" key would be "theme".
fn get_string_final(
  context: Context,
  key: String,
) -> Result(String, ContextError) {
  case context {
    CDict(d) -> {
      case dict.get(d, key) {
        Ok(value) -> {
          case value {
            CInt(i) -> Ok(int.to_string(i))
            CString(s) -> Ok(s)
            _ -> Error(UnexpectedContextType(key))
          }
        }
        _ -> Error(KeyNotFound(key))
      }
    }
    _ -> Error(UnexpectedContextType(key))
  }
}

pub fn get_string(
  context: Context,
  key: String,
) -> Result(String, ContextError) {
  case string.split(key, on: ".") {
    [key1] -> get_string_final(context, key1)
    [key1, key2, ..] -> {
      case get(context, key1) {
        Ok(dict1) -> get_string(dict1, key2)
        Error(_) -> Error(ValueNotFound(key1))
      }
    }
    [] -> Error(ValueNotFound(key))
  }
}

pub fn add_strings(
  context: Context,
  key: String,
  values: List(String),
) -> Context {
  case context {
    CDict(d) ->
      CDict(dict.insert(
        d,
        key,
        CList(list.map(values, fn(value) { CString(value) })),
      ))
    _ -> context
  }
}

pub fn add(context: Context, key: String, value: Context) -> Context {
  case context {
    CDict(d) -> CDict(dict.insert(d, key, value))
    _ -> context
  }
}

pub fn add_list(context: Context, key: String, value: List(Context)) -> Context {
  case context {
    CDict(d) -> CDict(dict.insert(d, key, CList(value)))
    _ -> context
  }
}
