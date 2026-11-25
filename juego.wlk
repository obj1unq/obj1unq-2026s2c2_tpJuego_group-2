import wollok.game.*
import direccionesConSolidos.*
import caramelos.*
import ladronYArbusto.*
import hermanos.*

object generador {
  const tiposDeCaramelo = [bonobom, tita]
  const tiposDeSuperCaramelos = [ferreroRocher]
const bordes = #{} // Guardamos acá todos los arbustos sólidos del borde

  method generarBosqueSolido() {
    const ancho = game.width() - 1
    const alto = game.height() - 1

    (0..ancho).forEach({ x =>
      self.agregarBorde(game.at(x, 0))
      self.agregarBorde(game.at(x, alto))
    })

    (1..alto - 1).forEach({ y =>
      self.agregarBorde(game.at(0, y))
      if (y != meta.position().y()) {
        self.agregarBorde(game.at(ancho, y))
      }
    })
  }

  method agregarBorde(posicion) {
    const borde = new BosqueSolido(position = posicion)
    bordes.add(borde)
    game.addVisual(borde)
  }
  method posicionAleatoria() {
    return game.at(
      (0..game.width() - 1).anyOne(),
      (0..game.height() - 1).anyOne()
    )
  }

  // Lista con las posiciones de los elementos fijos que NO se pueden pisar en un nivel
  method posicionesProhibidas() {
    const base = [
      hermanos.position(),
      contadorDeCaramelos.position(),
      vidas.position(),
      meta.position()
    ] + meta.posicionesProhibidas()

    if (game.hasVisual(entradaTienda)) {
      return base + [entradaTienda.position()]
    }
    return base
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

    if (tieneLadron) {
      const ladron = new Ladron(position = posicion)
      game.addVisual(ladron)
    }
    game.addVisual(arbusto)
  }

  method crearArbustoAleatoriamente() {
    self.crearArbusto(self.posicionValidaAleatoria())
  }

  method limpiarNivelAnterior() {
    const objetosPermanentes = #{hermanos, contadorDeCaramelos, vidas, inventario, meta, cartelPregunta}.union(bordes)
    const objetosAEliminar = game.allVisuals().filter({ visual => not objetosPermanentes.contains(visual) })
    

    objetosAEliminar.forEach({ visual =>
      if (game.hasVisual(visual)) {
        game.removeVisual(visual)
      }
    })
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
    } else {
      game.say(hermanos, "¡Llegaste al nivel final " + nivelMaximo.toString() + "!")
    }
  }

  method cargarNivelActual() {
    generador.limpiarNivelAnterior()
    game.boardGround(fondos.anyOne())
    hermanos.position(game.at(1, 5))
    self.añadirObjetos()

    if (self.debeAparecerEntradaTienda() and not game.hasVisual(entradaTienda)) {
      game.addVisual(entradaTienda)
      game.say(hermanos, "¡Hay una entrada a la tienda!")
    } else {
      game.say(hermanos, "¡Avanzaste al nivel " + dificultad.toString() + "!")
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
  method position() = game.at(game.width() - 1, 2)
  method solido() { return false }
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
    return (-3..0).map({ dx =>
      (-1..1).map({ dy =>
        game.at(self.position().x() + dx, self.position().y() + dy)
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
      game.say(self, "¡Querés cambiar 2 caramelos por un super caramelo? Interactuá con los botones.")
      self.ofrecerIntercambio()
    }
  }

  method ofrecerIntercambio() {
    esperandoDecision = true
    if (not game.hasVisual(botonAceptar)) {
      game.addVisual(botonAceptar)
    }
    if (not game.hasVisual(botonRechazar)) {
      game.addVisual(botonRechazar)
    }
  }

  method aceptarIntercambio() {
    if (esperandoDecision) {
      self.ocultarBotones()
      if (contadorDeCaramelos.cantidad() >= 2 and not inventario.estaLleno()) {
        inventario.consumirCaramelos(2)
        const nuevoSuper = new SuperCaramelo(position = game.at(6, 5), tipoDeSuperCaramelo = ferreroRocher)
        inventario.guardarSuperCaramelo(nuevoSuper)
        game.addVisual(nuevoSuper)
        game.say(self, "¡Trato hecho! Guardé tu super caramelo en el inventario.")
      } else if (contadorDeCaramelos.cantidad() >= 2 and inventario.estaLleno()) {
        game.say(self, "¡Tenés el inventario lleno! No podés sumar más super caramelos.")
      } else {
        game.say(self, "¡Necesitás al menos 2 caramelos para hacer el intercambio!")
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
    if (not game.hasVisual(vendedor)) {
      game.addVisual(vendedor)
    }
    if (not game.hasVisual(salidaTienda)) {
      game.addVisual(salidaTienda)
    }
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
  var property position = game.at(1, 1)
  method image() = "entradaSalidaTienda.png"
  method solido() = false

  method interactuar() {
    tienda.salir()
  }
}