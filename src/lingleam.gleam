import lustre as l
import model_controller.{init, update}
import view.{view}

pub fn main() {
  let app = l.application(init, update, view)
  let assert Ok(_) = l.start(app, "#app", Nil)
  Nil
}
