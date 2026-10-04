import wollok.game.*

object hermanos {
  var property position = game.at(3, 7)
  
  method image() = "fantasmasboo.png"
}

class Caramelo {
  const property image = "caramelo.png"
  
  method interactuar() {
    game.removeVisual(self)
    contadorDeCaramelos.sumarUnCaramelo()
  }
}

object caramelo {
  const property position = game.at(3, 5)
  const property image = "caramelo.png"
  
  method interactuar() {
    game.removeVisual(self)
    contadorDeCaramelos.sumarUnCaramelo()
  }
}

object contadorDeCaramelos {
  var property cantidad = 0
  const property position = game.at(1, 8)
  
  method text() = self.cantidad().toString() + " caramelos"
  
  method sumarUnCaramelo() {
    cantidad += 1
  }
}

object nivel1 {
  const posiciones = #{}
  
}