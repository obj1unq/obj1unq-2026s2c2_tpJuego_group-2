import wollok.game.*
object hermanos {
  var property position = game.at(3, 7)
  var property conQuienHablo = null
  
  method image() = "fantasmasboo.png"

  method tienenCaramelos(){
    return contadorDeCaramelos.cantidad()>= 1
  }

  method estanEnPosicionDeArbusto() {
    return self.position() == arbusto.position()
  }
  method responder(unaRespuesta){
      conQuienHablo.responder(unaRespuesta)
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
  method identidad() {
    return self.identity()
  }
	method esCorrecta(unaRespuesta) {
		return respuestaCorrecta == unaRespuesta
	}
}

const preguntaAcertijo = new Pregunta(
	texto = "¿2 + 2 = 4? (Presiona V o F)",
	respuestaCorrecta = "v"
)
const preguntaAcertijo2 = new Pregunta(
	texto = "¿2 + 2 = 4? (Presiona V o F)",
	respuestaCorrecta = "v"
)
class Ladron {
	var property position = arbusto.position()
	var property image = "arbusto-ladron.png"
	var property pregunta 
  	var esperandoRespuesta = false
  var hizoProgunta = false

	method interactuar() {
		self.asaltarHermanos()
	}

	method asaltarHermanos() {
				if (not esperandoRespuesta) {
			self.hacerPregunta()
		}
	}

	method hacerPregunta() {
		esperandoRespuesta = true
		pregunta.realizar(self)
    game.onTick(1000, pregunta.identidad(), {pregunta.realizar(self)})
    hermanos.conQuienHablo(self)
	}

	method responder(unaRespuesta) {
		/*if (esperandoRespuesta and !hizoProgunta) {*/
    game.removeTickEvent(pregunta.identidad())
			if (pregunta.esCorrecta(unaRespuesta)) {
				game.say(self, "¡Rayos, es correcto! Te salvaste...")
        esperandoRespuesta = false
        hizoProgunta = true

			} else {
				game.say(self, "¡Incorrecto!")
				self.robarCaramelo()
        esperandoRespuesta = false
        hizoProgunta = true
			}
		 
	}

	method robarCaramelo() {
		if (hermanos.tienenCaramelos()) {
			contadorDeCaramelos.restarCaramelo()
			game.say(self, "¡Te robé un caramelo muajaja!")
		} else {
			game.say(self, "¡No tienes caramelos para robar!")
		}
	}
}

class Arbusto {
    var property position 
    var property image = "arbusto.png"

    method interactuar() {
    game.removeVisual(self)
  }
}

const arbusto = new Arbusto(position = game.at(5, 5))
const ladron = new Ladron(position = arbusto.position(),pregunta = preguntaAcertijo)

const arbusto2 = new Arbusto(position = game.at(7, 7))
const ladron2 = new Ladron(position = arbusto2.position(),pregunta = preguntaAcertijo2)
