import gleam/int
import gleam/list
import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h
import lustre/event as e
import model as m

import library/webdata.{Loading, Some}

pub fn view(model: m.Model) -> el.Element(m.Msg) {
  h.div([], [
    h.button([e.on_click(m.UserIncrementedCount)], [el.text("+")]),
    el.text(model.count |> int.to_string),
    h.button([e.on_click(m.UserDecrementedCount)], [el.text("-")]),
    h.div([], cats_block(model)),
  ])
}

pub fn cats_block(model: m.Model) -> List(el.Element(m.Msg)) {
  let closure = fn(cat) {
    h.img([a.class("w-64 h-64"), a.src("https://cataas.com/cat/" <> cat)])
  }
  case model.cats {
    Some(cats) -> list.map(cats, closure)
    Loading(cats) -> [
      h.p([], [el.text("Loading...")]),
      ..list.map(cats, closure)
    ]
  }
}
