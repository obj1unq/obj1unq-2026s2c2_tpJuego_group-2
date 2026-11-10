import wollok.game.*

object hermanos {
  var property position = game.at(3, 7)
  var property conQuienHablo = null
  var armaEnUso = null
  
  method image() = "fantasmasboo.png"

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
}

object generador {
  const tiposDeCaramelo = [bonobom, tita]
  const tiposDeArmas = [cuchillo, navaja, martillo]

  method crearCaramelo(posicion) {
    game.addVisual(new Caramelo(position = posicion, tipoDeCaramelo = tiposDeCaramelo.anyOne()))
  }

  method crearCarameloAleatoriamente() {
    self.crearCaramelo(self.posicionAleatoria())
  }

  method crearArma(posicion) {
    game.addVisual(new Arma(position = posicion, tipoDeArma = tiposDeArmas.anyOne()))
  }

  method crearArmaAleatoriamente() {
    self.crearArma(self.posicionAleatoria())
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

object bonobom {}
object tita {}

object contadorDeCaramelos {
  var property cantidad = 0
  const property position = game.at(1, 8)
  
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
    pregunta.realizar(self)
    game.onTick(1000, pregunta.identidad(), { pregunta.realizar(self) })
    hermanos.conQuienHablo(self)
  }

  method responder(unaRespuesta) {
    if (esperandoRespuesta) {
      game.removeTickEvent(pregunta.identidad())
      if (pregunta.esCorrecta(unaRespuesta)) {
        game.say(self, "¡Rayos, es correcto! Te salvaste...")
      } else {
        game.say(self, "¡Incorrecto!")
        self.robarCaramelo()
      }
      esperandoRespuesta = false
      hizoPregunta = true
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

class Arma {
  const property position 
  const tipoDeArma
  var property poder = 10

  method image() {
    return "arma-" + tipoDeArma.toString() + ".png"
  }
 
  method interactuar() {
    game.removeVisual(self)
    inventario.guardarArma(self)
  }
}

object cuchillo {}
object martillo {}
object navaja {}

const arbusto = new Arbusto(position = game.at(5, 5))
const ladron = new Ladron(position = arbusto.position(), pregunta = preguntaAcertijo)

const arbusto2 = new Arbusto(position = game.at(7, 7))
const ladron2 = new Ladron(position = arbusto2.position(), pregunta = preguntaAcertijo2)

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
    return armas.filter({ arma => arma.poder() == _poder })
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