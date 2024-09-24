import controller as c
import lustre as l
import view as v

pub fn main() {
  let app = l.application(c.init, c.update, v.view)
  let assert Ok(_) = l.start(app, "#app", Nil)
  Nil
}
