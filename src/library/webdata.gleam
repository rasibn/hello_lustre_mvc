pub type Future(a) {
  Some(a)
  Loading(a)
}

pub fn to_some(web_data: Future(a)) -> Future(a) {
  case web_data {
    Some(thing) -> Some(thing)
    Loading(thing) -> Some(thing)
  }
}

pub fn to_loading(web_data: Future(a)) -> Future(a) {
  case web_data {
    Some(thing) -> Loading(thing)
    Loading(thing) -> Loading(thing)
  }
}

pub fn unwrap(web_data: Future(a)) -> a {
  case web_data {
    Some(thing) -> thing
    Loading(thing) -> thing
  }
}
