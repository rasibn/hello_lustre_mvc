import library/webdata as w
import lustre_http

pub type Model {
  Model(count: Int, cats: w.Future(Cats))
}

pub type Cats =
  List(String)

pub type Msg {
  UserIncrementedCount
  UserDecrementedCount
  ApiReturnedCat(Result(String, lustre_http.HttpError))
}
