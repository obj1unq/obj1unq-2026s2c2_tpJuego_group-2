import wollok.game.*
import direccionesConSolidos.*
import caramelos.*
import ladronYArbusto.*
import hermanos.*

object generador {
  const tiposDeCaramelo = [bonobom, tita]
  const tiposDeSuperCaramelos = [ferreroRocher]

  method posicionAleatoria() {
    return game.at(
      (0..game.width() - 1).anyOne(),
      (0..game.height() - 1).anyOne()
    )
  }

  // Lista con las posiciones de los elementos fijos que NO se pueden pisar en un nivel
  method posicionesProhibidas() {
    return [
      hermanos.position(),
      contadorDeCaramelos.position(),
      vidas.position(),
      meta.position()
    ] + meta.posicionesProhibidas()
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
    const objetosPermanentes = #{hermanos, contadorDeCaramelos, vidas, inventario, meta, cartelPregunta}
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

  method cargarNivelActual() {
    generador.limpiarNivelAnterior()
    game.boardGround(fondos.anyOne())
    hermanos.position(game.at(0, 5))
    self.añadirObjetos()
    game.say(hermanos, "¡Avanzaste al nivel " + dificultad.toString() + "!")
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
    return (0..4).map({ x =>
      (0..4).map({ y =>
        game.at(position.x() + x, position.y() + y)
      })
    }).flatten()
  }
}