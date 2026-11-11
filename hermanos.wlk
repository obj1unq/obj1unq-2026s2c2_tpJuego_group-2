import wollok.game.*
import direcciones.*
import caramelos.*
import ladronYArbusto.*
import juego.*

object hermanos {
  var property position = game.at(3, 7)
  var property conQuienHablo = null
  var superCarameloActual = null
  
  method image() = "fantasmasboo.png"

  method mover(direccion) {
  position = direccion.siguiente(position)
  }

  method tienenCaramelos() {
    return contadorDeCaramelos.cantidad() >= 1
  }

  method estanEnPosicionDeArbusto() {
    return self.position() == arbusto.position()
  }

  method responder(unaRespuesta) {
    if (conQuienHablo != null) {
      conQuienHablo.responder(unaRespuesta)
    }
  }

 method usarSuperCaramelo() {
    inventario.superCarameloEnUso(superCarameloActual)
  }

  method guardarSuperCaramelo() {
    if (superCarameloActual != null) {
      inventario.guardarSuperCaramelo(superCarameloActual)
      superCarameloActual = null
    }
  }

  method cambiarDeSuperCaramelo(_superCarameloNuevo) {
    inventario.cambiarDeSuperCaramelo(_superCarameloNuevo, superCarameloActual)
    superCarameloActual = _superCarameloNuevo
  }
}

object inventario {
  var property superCaramelos = #{}
  var property image = "inventario.png"
  var dueñoDelInventario = hermanos

  method guardarSuperCaramelo(_superCaramelo) {
    superCaramelos.add(_superCaramelo)
  }
   
  method superCarameloEnUso(_superCaramelo) {
    if (self.existeSuperCaramelo(_superCaramelo)) {
      superCaramelos.remove(_superCaramelo)
    } else {
      cartelPregunta.text("El super caramelo no está en el inventario para usarla")
    }
  }

  method superCarameloConConPoder(_superCaramelo) {
    return superCaramelos.filter({ superCaramelo => superCaramelo.poder() == _superCaramelo })
  }
   
  method cambiarDeSuperCaramelo(_superCarameloNuevo, _superCarameloViejo) {
    self.validarCambiarDeSuperCaramelo(_superCarameloNuevo)
    superCaramelos.remove(_superCarameloNuevo)
    if (_superCarameloViejo != null) {
      superCaramelos.add(_superCarameloViejo)
    }
  }
   
  method validarCambiarDeSuperCaramelo(_superCaramelo) {
    if (not self.existeSuperCaramelo(_superCaramelo)) {
      game.say(dueñoDelInventario, "El super caramelo pedido no está en el inventario")
    }
  }
   
  method existeSuperCaramelo(_superCaramelo) {
    return superCaramelos.contains(_superCaramelo)
  }
}
object vidas {
    var cantDeVida = 7
    const property position = game.at(0, 9)

    method image() {
        return "vida-" + cantDeVida.toString() + ".png"
    }

    method perderMediaVida() {
        cantDeVida = (cantDeVida - 1).max(1)
    }
}