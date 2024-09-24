import gleam/dynamic
import lustre/effect
import lustre_http
import model as m
import webdata

pub fn init(_flags) -> #(m.Model, effect.Effect(m.Msg)) {
  #(m.Model(0, webdata.Some([])), effect.none())
}

pub fn update(model: m.Model, msg: m.Msg) {
  case msg {
    m.UserIncrementedCount -> {
      let cat = model.cats |> webdata.to_loading
      #(m.Model(cats: cat, count: model.count + 1), get_cat())
    }
    m.UserDecrementedCount -> #(
      m.Model(..model, count: model.count - 1),
      effect.none(),
    )
    m.ApiReturnedCat(Ok(cat)) -> {
      let cats = model.cats |> webdata.unwrap
      #(m.Model(..model, cats: webdata.Some([cat, ..cats])), effect.none())
    }
    m.ApiReturnedCat(Error(_)) -> #(model, effect.none())
  }
}

fn get_cat() {
  let decoder = dynamic.field("_id", dynamic.string)
  let expect = lustre_http.expect_json(decoder, m.ApiReturnedCat)
  lustre_http.get("https://cataas.com/cat?json=true", expect)
}
