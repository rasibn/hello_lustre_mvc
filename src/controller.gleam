import gleam/dynamic
import library/webdata as w
import lustre/effect
import lustre_http
import model as m

pub fn init(_flags) -> #(m.Model, effect.Effect(m.Msg)) {
  #(m.Model(0, w.Some([])), effect.none())
}

pub fn update(model: m.Model, msg: m.Msg) {
  case msg {
    m.UserIncrementedCount -> {
      let cat = model.cats |> w.to_loading
      #(m.Model(cats: cat, count: model.count + 1), get_cat())
    }
    m.UserDecrementedCount -> #(
      m.Model(..model, count: model.count - 1),
      effect.none(),
    )
    m.ApiReturnedCat(Ok(cat)) -> {
      let cats = model.cats |> w.unwrap
      #(m.Model(..model, cats: w.Some([cat, ..cats])), effect.none())
    }
    m.ApiReturnedCat(Error(_)) -> #(model, effect.none())
  }
}

fn get_cat() {
  let decoder = dynamic.field("_id", dynamic.string)
  let expect = lustre_http.expect_json(decoder, m.ApiReturnedCat)
  lustre_http.get("https://cataas.com/cat?json=true", expect)
}
