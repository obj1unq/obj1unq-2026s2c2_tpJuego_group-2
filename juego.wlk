import wollok.game.*

object hermanos {
  var property position = game.at(3, 7)
  
  method image() = "fantasmasboo.png"
}

class Caramelo {
  const property position

  method image() {
    return "caramelo" + 1.randomUpTo(2).toString() + ".png"
  }
 
  method interactuar() {
    game.removeVisual(self)
    contadorDeCaramelos.sumarUnCaramelo()
  }

  method text() = "caramelo" 
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