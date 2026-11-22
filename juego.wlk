import wollok.game.*
import direccionesConSolidos.*
import caramelos.*
import ladronYArbusto.*
import hermanos.*


object generador {
  const tiposDeCaramelo = [bonobom, tita]
  const tiposDeSuperCaramelos = [ferreroRocher]

  method posicionAleatoria() {
    return game.at((0..game.width() - 1).anyOne(),
                   (0..game.height() - 1).anyOne())
  }

    // Lista con las posiciones de los elementos fijos que NO se pueden pisar
  method posicionesProhibidas() {
    return [
      hermanos.position(),
      contadorDeCaramelos.position(),
      vidas.position()
    ]
    + meta.posicionesProhibidas()
  }

  // Evalúa si una posición está libre de objetos fijos y de otros elementos ya generados
  method esPosicionValida(posicion) {
    return not self.posicionesProhibidas().contains(posicion) 
           and game.getObjectsIn(posicion).isEmpty()
  }

  // Busca de forma recursiva hasta encontrar una posición totalmente válida
  method posicionValidaAleatoria() { 
    const posicion = self.posicionAleatoria() 
    return if (self.esPosicionValida(posicion)) posicion 
           else self.posicionValidaAleatoria() 
  }

  method crearCaramelo(posicion) {
    game.addVisual(new Caramelo(position = posicion, tipoDeCaramelo = tiposDeCaramelo.anyOne()))
  }

  method crearCarameloAleatoriamente() {
    self.crearCaramelo(self.posicionValidaAleatoria())
  }

  method crearsuperCaramelo(posicion) {
    game.addVisual(new SuperCaramelo(position = posicion, tipoDeSuperCaramelo = tiposDeSuperCaramelos.anyOne()))
  }

  method crearsuperCarameloAleatoriamente() {
    self.crearsuperCaramelo(self.posicionValidaAleatoria())
  }

  method crearArbusto(posicion) { 
    const arbusto = new Arbusto(position = posicion) 
    const tieneLadron = [true, false].anyOne()

    if (tieneLadron) { const ladron = new Ladron(position = posicion) 
    game.addVisual(ladron)
    } 
    game.addVisual(arbusto) 
  } 

  method crearArbustoAleatoriamente() {
    self.crearArbusto(self.posicionValidaAleatoria())
  }


  method limpiarNivelAnterior() {
  const objetosPermanentes = #{hermanos, contadorDeCaramelos, vidas, inventario, meta, cartelPregunta}
  const objetosAEliminar = game.allVisuals().filter({ visual => not objetosPermanentes.contains(visual) })
  
  objetosAEliminar.forEach({ visual => game.removeVisual(visual) })
  }

}

object administradorDeNiveles {
    var property dificultad = 1
    const nivelMaximo = 9
    const fondos = ["1erfondo.jpg", "2dofondo.jpg", "3erfondo.jpg"]

    method pasarASiguienteNivel() {
        if (dificultad < nivelMaximo) {
            dificultad = dificultad + 1
            self.cargarNivelActual()
        } else {
            game.say(hermanos, "¡Llegaste al nivel final " + nivelMaximo.toString() + "!")
        }
    }

    method avanzarTrasTienda() {
        if (dificultad < nivelMaximo) {
            dificultad = dificultad + 1
            self.cargarNivelActual()
        }
    }

    method cargarNivelActual() {
        game.say(hermanos, "¡Avanzaste al nivel " + dificultad.toString() + "!")
        game.boardGround(fondos.anyOne())
        generador.limpiarNivelAnterior()
        hermanos.position(game.at(0, 5))
        self.añadirObjetos()

        if (self.debeAparecerEntradaTienda()) {
            game.addVisual(entradaTienda)
            game.say(hermanos, "¡Hay una entrada a la tienda!")
        }
    }

    method debeAparecerEntradaTienda() {
        return (dificultad % 3 == 0) and (dificultad < nivelMaximo)
    }

    method añadirObjetos() {
        const cantidad = dificultad * 2

        cantidad.times({ _ => generador.crearCarameloAleatoriamente() })
        cantidad.times({ _ => generador.crearArbustoAleatoriamente() })

        if (dificultad >= 2) {
            generador.crearsuperCarameloAleatoriamente()
        }
    }
}

object meta {
    const property position = game.at(17, 3) 
    method solido() { return false}
    method image() {
        return "puerta.png" 
    }

    method interactuar() {
        if (contadorDeCaramelos.cantidad() >= 2) {
            game.say(hermanos, "¡Cumplimos el objetivo! Avanzamos al siguiente nivel.")
            
            administradorDeNiveles.pasarASiguienteNivel()
            
        } else {
            game.say(hermanos, "¡Aún faltan caramelos para poder avanzar!")
        }
    }

    method posicionesProhibidas() {
        return (0..4).map({ x =>
                  (0..4).map({ y => 
                    (game.at(position.x() + x, position.y() + y))
                  })     
                }).flatten()
      }
}


object entradaTienda {
	var property position = game.at(17, 1)
	method image() = "entradaSalidaTienda.png"
	method solido() = false

	method interactuar() {
		tienda.entrar()
	}
}

object botonAceptar {
	var property position = game.at(6, 6)
	method image() = "botonAceptar.png"
	method solido() = false

	method interactuar() {
		vendedor.aceptarIntercambio()
	}
}

object botonRechazar {
	var property position = game.at(8, 6)
	method image() = "botonRechazar.png"
	method solido() = false

	method interactuar() {
		vendedor.rechazarIntercambio()
	}
}

object vendedor {
	var property position = game.at(7, 6)
	var esperandoDecision = false
	method image() = "vendedor.png"
	method solido() = true

	method interactuar() {
		if (not esperandoDecision) {
			game.say(self, "¡Querés cambiar 2 caramelos por un super caramelo? (Y = Aceptar / N = Rechazar)")
			self.ofrecerIntercambio()
		}
	}

	method ofrecerIntercambio() {
		esperandoDecision = true
		game.addVisual(botonAceptar)
		game.addVisual(botonRechazar)
	}

	method aceptarIntercambio() {
		if (esperandoDecision) {
			self.ocultarBotones()
			if (contadorDeCaramelos.cantidad() >= 2 and not inventario.estaLleno()) {
				contadorDeCaramelos.restarCaramelo()
				contadorDeCaramelos.restarCaramelo()
				const nuevoSuper = new SuperCaramelo(position = game.at(6, 5), tipoDeSuperCaramelo = ferreroRocher)
				game.addVisual(nuevoSuper)
				game.say(self, "¡Trato hecho! Ahí tenés tu super caramelo.")
			} else if (contadorDeCaramelos.cantidad() >= 2 and inventario.estaLleno()) {
				game.say(self, "¡Tenés el inventario lleno! No podés sumar más super caramelos.")
			} else if (contadorDeCaramelos.cantidad() >= 1) {
				contadorDeCaramelos.restarCaramelo()
				contadorDeCaramelos.sumarUnCaramelo()
				game.say(self, "¡Intercambio de caramelo realizado! Juntá 2 para un super caramelo.")
			} else {
				game.say(self, "¡No tenés caramelos suficientes para el intercambio!")
			}
		}
	}

	method rechazarIntercambio() {
		if (esperandoDecision) {
			self.ocultarBotones()
			game.say(self, "¡Todo bien! Avisame si cambiás de opinión.")
		}
	}

	method ocultarBotones() {
		esperandoDecision = false
		if (game.hasVisual(botonAceptar)) {
			game.removeVisual(botonAceptar)
		}
		if (game.hasVisual(botonRechazar)) {
			game.removeVisual(botonRechazar)
		}
	}
}

object tienda {
	method entrar() {
		game.say(hermanos, "¡Entramos a la tienda!")
		generador.limpiarNivelAnterior()
		game.boardGround("fondoTienda.png")
		hermanos.position(game.at(2, 5))
		game.addVisual(vendedor)
		game.addVisual(salidaTienda)
	}

	method salir() {
		vendedor.ocultarBotones()
		if (game.hasVisual(vendedor)) {
			game.removeVisual(vendedor)
		}
		if (game.hasVisual(salidaTienda)) {
			game.removeVisual(salidaTienda)
		}
		administradorDeNiveles.avanzarTrasTienda()
	}
}

object salidaTienda {
	var property position = game.at(14, 5)
	method image() = "entradaSalidaTienda.png"
	method solido() = false

	method interactuar() {
		tienda.salir()
	}
}