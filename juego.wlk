import wollok.game.*

object hermanos {
    var property position = game.at(3, 7)
    
    method image() = "fantasmasboo.png"

    method tienenCaramelos() {
        return contadorDeCaramelos.cantidad() >= 1
    }
    
    method estanEnPosicionDeArbusto() {
        return arbusto.position() == self.position()
    }
}

class Caramelo {
    const property image = "caramelo.png"
    const property position
    
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
    
    method restarCaramelo() {
        cantidad = cantidad - 1
    }
}

object nivel1 {
    const posiciones = #{}
}

object ladron {
    var property position = arbusto.position()
    var property image = "ladron.png"

    method asaltarHermanos() {
      if (hermanos.estanEnPosicionDeArbusto()) {
        if (hermanos.tienenCaramelos()) {
          self.robarCaramelo()
            } else {
                self.hacerPreguntaDeOrga()
            }
        }
    }

    method robarCaramelo() {
        contadorDeCaramelos.restarCaramelo()
        game.say(self, "¡Te robé un caramelo muajaja!")
    }

    method hacerPreguntaDeOrga() {
    }
}

object arbusto {
    var property position = game.at(3, 2) 
    var property image = "arbusto.png" 
}