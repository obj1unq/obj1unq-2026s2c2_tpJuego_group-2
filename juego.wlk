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
  const property position = game.at(1, 9)
  
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
const ladron = new Ladron(position = arbusto.position())

const arbusto2 = new Arbusto(position = game.at(7, 7))
const ladron2 = new Ladron(position = arbusto2.position())

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
      cartelPregunta.text("El arma no está en el inventario para usarla")
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