pub type WebData(a) {
  Some(a)
  Loading(a)
}

pub fn to_some(web_data: WebData(a)) -> WebData(a) {
  case web_data {
    Some(thing) -> Some(thing)
    Loading(thing) -> Some(thing)
  }
}

pub fn to_loading(web_data: WebData(a)) -> WebData(a) {
  case web_data {
    Some(thing) -> Loading(thing)
    Loading(thing) -> Loading(thing)
  }
}

pub fn unwrap(web_data: WebData(a)) -> a {
  case web_data {
    Some(thing) -> thing
    Loading(thing) -> thing
  }
}
