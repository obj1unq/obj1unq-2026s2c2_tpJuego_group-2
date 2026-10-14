import wollok.game.*
object hermanos {
  var property position = game.at(3, 7)
  
  method image() = "fantasmasboo.png"
}

object generador {
  const tiposDeCaramelo = [bonobom, tita]
  const tiposDeArmas = [cuchillo,navaja,martillo]

  method crearCaramelo(posicion) {
    game.addVisual(new Caramelo(position = posicion,tipoDeCaramelo = tiposDeCaramelo.anyOne()))
  }
  method crearCarameloAleatoriamente() {
    self.crearCaramelo(self.posicionAleatoria())
  }
  method crearArma(posicion) {
    game.addVisual(new Arma(position = posicion,tipoDeArma = tiposDeArmas.anyOne()))
  }
  method crearArmaAleatoriamente() {
    self.crearArma(self.posicionAleatoria())
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

   method textColor() = "#ffffff"

   method textSize() = 100
  
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

class Arma {
  const property position 
  const tipoDeArma

  method image() {
    return "arma-" + tipoDeArma.toString() + ".png"
  }
 
  method interactuar() {
    game.removeVisual(self)
    //inventario.AgregarArma(self)
  }
}

object cuchillo {
  
}
object martillo {
  
}
object navaja {
  
}