import gleam/int
import gleam/list
import library/webdata as w
import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h
import lustre/event as e
import model as m

pub fn view(model: m.Model) -> el.Element(m.Msg) {
  h.div([], [
    h.button([e.on_click(m.UserIncrementedCount)], [el.text("+")]),
    el.text(model.count |> int.to_string),
    h.button([e.on_click(m.UserDecrementedCount)], [el.text("-")]),
    h.div([], will_cats(model)),
  ])
}

pub fn will_cats(model: m.Model) -> List(el.Element(m.Msg)) {
  let closure = fn(cat) {
    h.img([a.class("w-64 h-64"), a.src("https://cataas.com/cat/" <> cat)])
  }
  case model.cats {
    w.Some(cats) -> list.map(cats, closure)
    w.Loading(cats) -> [
      h.p([], [el.text("Loading...")]),
      ..list.map(cats, closure)
    ]
  }
}
