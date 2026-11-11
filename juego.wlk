import wollok.game.*

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

object generador {
  const tiposDeCaramelo = [bonobom, tita]
  const tiposDeSuperCaramelos = [ferreroRocher]

  method crearCaramelo(posicion) {
    game.addVisual(new Caramelo(position = posicion, tipoDeCaramelo = tiposDeCaramelo.anyOne()))
  }

  method crearCarameloAleatoriamente() {
    self.crearCaramelo(self.posicionAleatoria())
  }

  method crearsuperCaramelo(posicion) {
    game.addVisual(new SuperCaramelo(position = posicion, tipoDeSuperCaramelo = tiposDeSuperCaramelos.anyOne()))
  }

  method crearsuperCarameloAleatoriamente() {
    self.crearsuperCaramelo(self.posicionAleatoria())
  }

  method crearAleatoriamente() {
    self.crearCaramelo(self.posicionAleatoria())
  }

  method posicionAleatoria() {
    return game.at((0..game.width() - 1).anyOne(), (0..game.height() - 1).anyOne())
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

object ferreroRocher {
  
}
object bonobom {}
object tita {}

object contadorDeCaramelos {
  var property cantidad = 0
  const property position = game.at(19, 9)
  
  method text() = self.cantidad().toString() + " caramelos"
  method textColor() = "#ffffff"
  method textSize() = 100
  
  method sumarUnCaramelo() {
    cantidad += 1
  }

  method restarCaramelo() {
    cantidad = 0.max(cantidad - 1)
  }
}
 
object cartelPregunta { 
  var property position = game.at((game.width() - 1) / 2, 0) 
  var property text = "" 
  method textColor() = "#ffffff" 
  method textSize() = 100
  }

const preguntasDisponibles = [ 
new Pregunta(texto = "¿El sol es una estrella? (Presiona V o F)", respuestaCorrecta = "v"),  
new Pregunta(texto = "¿2 + 2 = 4? (Presiona V o F)", respuestaCorrecta = "v"),  
new Pregunta(texto = "¿Los peces vuelan? (Presiona V o F)", respuestaCorrecta = "f"), 
new Pregunta(texto = "¿Wollok es un lenguaje de objetos? (Presiona V o F)", respuestaCorrecta = "v"), 
new Pregunta(texto = "¿La luna es de queso? (Presiona V o F)", respuestaCorrecta = "f") 
]
class Pregunta {
  const property texto
  const property respuestaCorrecta

  method realizar(unVisual) {
    game.say(unVisual, texto)
  }

  method identidad() = self.identity().toString()

  method esCorrecta(unaRespuesta) {
    return respuestaCorrecta == unaRespuesta
  }
}

class Ladron {
  const property position = arbusto.position()
  const property image = "arbusto-ladron.png"
  const pregunta = preguntasDisponibles.anyOne()
  var esperandoRespuesta = false
  var hizoPregunta = false

  method interactuar() {
    self.asaltarHermanos()
  }

  method asaltarHermanos() {
    if (not esperandoRespuesta and not hizoPregunta) {
      self.hacerPregunta()
    }
  }

  method hacerPregunta() {
    esperandoRespuesta = true
    cartelPregunta.text(pregunta.texto())
    hermanos.conQuienHablo(self)
  }

  method responder(unaRespuesta) {
    if (esperandoRespuesta) {
      if (pregunta.esCorrecta(unaRespuesta)) {
        cartelPregunta.text("¡Rayos, es correcto! Te salvaste...")
      } else {
        self.robarCaramelo()
        vidas.perderMediaVida()
      }
      game.schedule(2000, { cartelPregunta.text("") })
      esperandoRespuesta = false
      hizoPregunta = true
    }
  }

  method robarCaramelo() {
    if (hermanos.tienenCaramelos()) {
      contadorDeCaramelos.restarCaramelo()
      cartelPregunta.text("¡Incorrecto! ¡Te robé un caramelo muajaja!")
    } else {
      cartelPregunta.text("¡Incorrecto! ¡No tienes caramelos para robar!")
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

class SuperCaramelo {
  const property position 
  const tipoDeSuperCaramelo
  var property poder = 10

  method image() {
    return "super-" + tipoDeSuperCaramelo.toString() + ".png"
  }
 
  method interactuar() {
    game.removeVisual(self)
    inventario.guardarSuperCaramelo(self)
  }
}

object cuchillo {}
object martillo {}
object navaja {}

const arbusto = new Arbusto(position = game.at(5, 5))
const ladron = new Ladron(position = arbusto.position())

const arbusto2 = new Arbusto(position = game.at(7, 7))
const ladron2 = new Ladron(position = arbusto2.position())

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