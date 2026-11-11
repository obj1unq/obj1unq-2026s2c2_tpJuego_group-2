import wollok.game.*
import direcciones.*
import caramelos.*
import ladronYArbusto.*
import hermanos.*

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

  method crearArbusto(posicion) { 
    const arbusto = new Arbusto(position = posicion) 
    const tieneLadron = [true, false].anyOne()

    if (tieneLadron) { const ladron = new Ladron(position = posicion) 
    game.addVisual(ladron)
    } 
    game.addVisual(arbusto) } 
  
  method crearArbustoAleatoriamente() { 
    self.crearArbusto(self.posicionAleatoria()) 
  }

}