import wollok.game.*
object hermanos {
<<<<<<< HEAD
  var property position = game.at(3, 7)
  var property conQuienHablo = null
  var armaEnUso = null
  
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
  method usarArma() {
    inventario.usarArma(armaEnUso)
  }
  method guardarArma() {
    if (armaEnUso != null) {
      inventario.guardarArma(armaEnUso)
      armaEnUso = null
    }
  }
  
  method cambiarDeArma(_armaNueva) {
    inventario.cambiarDeArma(_armaNueva, armaEnUso)
    armaEnUso = _armaNueva
  }

=======
    var property position = game.at(3, 7)
    
    method image() = "fantasmasboo.png"

    method tienenCaramelos() {
        return contadorDeCaramelos.cantidad() >= 1
    }
    
    method estanEnPosicionDeArbusto() {
        return arbusto.position() == self.position()
    }
>>>>>>> main
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
<<<<<<< HEAD
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
  
=======
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
>>>>>>> main
}

object tita {
  
}
object contadorDeCaramelos {
<<<<<<< HEAD
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


object inventario {
   var property armas = #{}
   var property image = "inventario.png"
   var dueñoDelInventario = hermanos

   method guardarArma(_arma) {
        armas.add(_arma)
   }
   
   method usarArma(_arma) {
        if (self.existeArma(_arma)) {
            armas.remove(_arma)
        } else {
            game.say(dueñoDelInventario, "El arma no está en el inventario para usarla")
        }
   }

   method armaConPoder(_poder) {
        return armas.filter({arma => arma.poder() == _poder})
   }
   
   method cambiarDeArma(_armaNueva, _armaVieja) {
        self.validarCambiarDeArma(_armaNueva)
        armas.remove(_armaNueva)
        if (_armaVieja != null) {
            armas.add(_armaVieja)
        }
   }
   
   method validarCambiarDeArma(_arma) {
        if (not self.existeArma(_arma)) {
            game.say(dueñoDelInventario, "El arma pedida no está en el inventario")
        }
   }
   
   method existeArma(_arma) {
        return armas.contains(_arma)
   }
}
=======
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
>>>>>>> main
