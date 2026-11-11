import wollok.game.*
import direcciones.*
import juego.*
import caramelos.*
import hermanos.*

class Ladron {
  const property position
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

class Arbusto {
  var property position 
  var property image = "arbusto.png"

  method interactuar() {
    game.removeVisual(self)
  }
}
