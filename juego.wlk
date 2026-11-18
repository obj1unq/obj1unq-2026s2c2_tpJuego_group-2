import wollok.game.*
import direcciones.*
import caramelos.*
import ladronYArbusto.*
import hermanos.*

object generador {
  const tiposDeCaramelo = [bonobom, tita]
  const tiposDeSuperCaramelos = [ferreroRocher]

  method posicionAleatoria() {
    return game.at((0..game.width() - 1).anyOne(), (0..game.height() - 1).anyOne())
  }

  method posicionValidaAleatoria() { 
    const posicion = self.posicionAleatoria() 
    return if (posicion != hermanos.position()) posicion 
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
    const fondos = ["1erfondo.jpg", "2dofondo.jpg", "3erfondo.jpg"]
    

    method pasarASiguienteNivel() {
        dificultad = dificultad +1
        game.say(hermanos, "¡Avanzaste al nivel " + dificultad.toString() + "!")
        game.boardGround(fondos.anyOne())
        generador.limpiarNivelAnterior()
        hermanos.position(game.at(0, 5))
        self.añadirObjetos()
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
    const property position = game.at(15, 5) 
    
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
}