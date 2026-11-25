import wollok.game.*
import direccionesConSolidos.*
import juego.*
import ladronYArbusto.*
import hermanos.*

class Caramelo {
  const property position
  const property tipoDeCaramelo

  method solido() { return false }

  method image() {
    return "caramelo-" + tipoDeCaramelo.toString() + ".png"
  }

  method interactuar() {
    game.removeVisual(self)
    contadorDeCaramelos.sumarUnCaramelo()
  }
}

object ferreroRocher {}
object bonobom {}
object tita {}

object contadorDeCaramelos {
  var property cantidad = 0
  const property position = game.at(19, 9)

  method text() = self.cantidad().toString() + " caramelos"
  method textColor() = "#ffffff"
  method textSize() = 100

  method sumarUnCaramelo() {
    cantidad += 1
  }

  method restarCaramelo() {
    cantidad = 0.max(cantidad - 1)
  }

  method restarCantidad(unaCantidad) {
    cantidad = 0.max(cantidad - unaCantidad)
  }
}

class SuperCaramelo {
  const property position
  const property tipoDeSuperCaramelo
  var property poder = 10

  method solido() { return false }

  method image() {
    return "super-" + tipoDeSuperCaramelo.toString() + ".png"
  }

  method interactuar() {
    game.removeVisual(self)
  }
}

