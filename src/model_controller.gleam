import gleam/dynamic

import lustre/effect
import lustre_http

import webdata

pub type Model {
  Model(count: Int, cats: webdata.WebData(Cats))
}

pub type Cats =
  List(String)

pub fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  #(Model(0, webdata.Some([])), effect.none())
}

pub type Msg {
  UserIncrementedCount
  UserDecrementedCount
  ApiReturnedCat(Result(String, lustre_http.HttpError))
}

pub fn update(model: Model, msg: Msg) {
  case msg {
    UserIncrementedCount -> {
      let cat = model.cats |> webdata.to_loading
      #(Model(cats: cat, count: model.count + 1), get_cat())
    }
    UserDecrementedCount -> #(
      Model(..model, count: model.count - 1),
      effect.none(),
    )
    ApiReturnedCat(Ok(cat)) -> {
      let cats = model.cats |> webdata.unwrap
      #(Model(..model, cats: webdata.Some([cat, ..cats])), effect.none())
    }
    ApiReturnedCat(Error(_)) -> #(model, effect.none())
  }
}

fn get_cat() {
  let decoder = dynamic.field("_id", dynamic.string)
  let expect = lustre_http.expect_json(decoder, ApiReturnedCat)
  lustre_http.get("https://cataas.com/cat?json=true", expect)
}
