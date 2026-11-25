import wollok.game.*
import direccionesConSolidos.*
import juego.*
import ladronYArbusto.*
import hermanos.*

class Visual {
  const property position

  method image()
  method solido() = false
  method interactuar() {}
  
}

class Caramelo inherits Visual {
  const property tipoDeCaramelo

  override method image() = "caramelo-" + tipoDeCaramelo.toString() + ".png"
  override method interactuar() {
    game.removeVisual(self)
    inventario.guardarCaramelo(tipoDeCaramelo)
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


class SuperCaramelo inherits Visual {
  const property tipoDeSuperCaramelo
  var property poder = 10

  override method image() = "super-" + tipoDeSuperCaramelo.toString() + ".png"

  override method interactuar() {
    game.removeVisual(self)
    inventario.guardarSuperCaramelo(self)
  }
}

class EntradaCaramelo {
  const property tipo
  var property cantidad = 1

  method sumar(unaCantidad) {
    cantidad += unaCantidad
  }

  method restar(unaCantidad) {
    cantidad = 0.max(cantidad - unaCantidad)
  }

  method descripcion() = tipo.toString() + ": " + cantidad.toString()
}