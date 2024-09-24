import lustre_http

import library/webdata

pub type Model {
  Model(count: Int, cats: webdata.WebData(Cats))
}

pub type Cats =
  List(String)

pub type Msg {
  UserIncrementedCount
  UserDecrementedCount
  ApiReturnedCat(Result(String, lustre_http.HttpError))
}
