import wollok.game.*
object hermanos {
  var property position = game.at(3, 7)
  
  method image() = "fantasmasboo.png"
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
}


object nivel1 {
  const posiciones = #{}
  
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
	var property position = game.at(0, 0)
	var fueDescubierto = false
	var property pregunta // Instancia de la clase Pregunta

	method image() = if (fueDescubierto) "ladron.png" else "arbusto.png"

	method interactuar() {
		fueDescubierto = true
		self.hacerPregunta()
	}

	method hacerPregunta() {
		pregunta.realizar(self)
	}

	method responder(unaRespuesta) {
		return pregunta.esCorrecta(unaRespuesta)
	}
}





