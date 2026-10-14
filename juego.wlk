import wollok.game.*
object hermanos {
  var property position = game.at(3, 7)
  
  method image() = "fantasmasboo.png"

  method tienenCaramelos(){
    return contadorDeCaramelos.cantidad()>= 1
  }

  method estanEnPosicionDeArbusto() {
    return self.position() == arbusto.position()
  }
}

object generador {
  const tiposDeCaramelo = [bonobom, tita]
  method crearCaramelo(posicion) {
    game.addVisual(new Caramelo(position = posicion,tipoDeCaramelo = tiposDeCaramelo.anyOne()))
  }
  method crearAleatoriamente() {
    self.crearCaramelo(self.posicionAleatoria())
  }
  method posicionAleatoria() {
    return game.at((0..game.width()-1).anyOne(),(0..game.height()-1).anyOne())
  }
}
class Caramelo {
  const property position 
  const tipoDeCaramelo 

  method image() {
    return "caramelo-" + tipoDeCaramelo.toString() + ".png"
  }
 
  method interactuar() {
    game.removeVisual(self)
    contadorDeCaramelos.sumarUnCaramelo()
  }
}  

object bonobom {
  
}

object tita {
  
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


class Pregunta {
	const property texto
	const property respuestaCorrecta

	method realizar(unVisual) {
		game.say(unVisual, texto)
	}

	method esCorrecta(unaRespuesta) {
		return respuestaCorrecta == unaRespuesta
	}
}

class Ladron {
    var property position = arbusto.position()
    var property image = "arbusto-ladron.png"

    method asaltarHermanos() {
      if (hermanos.estanEnPosicionDeArbusto()) {
                self.hacerPreguntaDeOrga()
            }
    }

    method robarCaramelo() {
        contadorDeCaramelos.restarCaramelo()
        game.say(self, "¡Te robé un caramelo muajaja!")
    }

    method hacerPreguntaDeOrga() {
    }

    method interactuar() {
        self.asaltarHermanos()
    }
}

class Arbusto {
    var property position = game.at(3, 2) 
    var property image = "arbusto.png"

    method interactuar() {
    game.removeVisual(self)
  }
}


const arbusto = new Arbusto()