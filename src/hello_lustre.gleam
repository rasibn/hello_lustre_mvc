import gleam/dynamic
import gleam/int
import gleam/list

import lustre as l
import lustre/attribute as a
import lustre/effect
import lustre/element as el
import lustre/element/html as h
import lustre/event as e
import lustre_http

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

pub type Model {
  Model(count: Int, cats: WebData(Cats))
}

pub type Cats =
  List(String)

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  #(Model(0, Some([])), effect.none())
}

pub type Msg {
  UserIncrementedCount
  UserDecrementedCount
  ApiReturnedCat(Result(String, lustre_http.HttpError))
}

pub fn update(model: Model, msg: Msg) {
  case msg {
    UserIncrementedCount -> {
      let cat = model.cats |> to_loading
      #(Model(cats: cat, count: model.count + 1), get_cat())
    }
    UserDecrementedCount -> #(
      Model(..model, count: model.count - 1),
      effect.none(),
    )
    ApiReturnedCat(Ok(cat)) -> {
      let cats = model.cats |> unwrap
      #(Model(..model, cats: Some([cat, ..cats])), effect.none())
    }
    ApiReturnedCat(Error(_)) -> #(model, effect.none())
  }
}

fn get_cat() {
  let decoder = dynamic.field("_id", dynamic.string)
  let expect = lustre_http.expect_json(decoder, ApiReturnedCat)
  lustre_http.get("https://cataas.com/cat?json=true", expect)
}

pub fn view(model: Model) -> el.Element(Msg) {
  h.div([], [
    h.button([e.on_click(UserIncrementedCount)], [el.text("+")]),
    el.text(model.count |> int.to_string),
    h.button([e.on_click(UserDecrementedCount)], [el.text("-")]),
    h.div([], cats_block(model)),
  ])
}

pub fn cats_block(model: Model) -> List(el.Element(Msg)) {
  case model.cats {
    Some(cats) ->
      list.map(cats, fn(cat) {
        h.img([a.src("https://cataas.com/cat/" <> cat)])
      })
    Loading(cats) -> [
      h.p([], [el.text("Loading...")]),
      ..list.map(cats, fn(cat) {
        h.img([a.src("https://cataas.com/cat/" <> cat)])
      })
    ]
  }
}

pub fn main() {
  let app = l.application(init, update, view)
  let assert Ok(_) = l.start(app, "#app", Nil)
  Nil
}
