import wollok.game.*

object hermanos {
  var property position = game.at(3, 7)
  
  method image() = "fantasmasboo.png"
}

class Caramelo {
  const property image = "caramelo.png"
  const property position
  
  method interactuar() {
    game.removeVisual(self)
    contadorDeCaramelos.sumarUnCaramelo()
  } 
}

class ladron { 
  const property position 
  var fueDescubierto = false 
  
  method image(){ 
    if (fueDescubierto) "ladron.png" else "arbusto.png" 
  }

  method hacerPregunta(){
    
  }
  method interactuar() {
     fueDescubierto = true
     self.hacerPregunta()
  }
}



object contadorDeCaramelos {
  var property cantidad = 0
  const property position = game.at(1, 8)
  
  method text() = self.cantidad().toString() + " caramelos"
  
  method sumarUnCaramelo() {
    cantidad += 1
  }
}

object nivel1 {
  const posiciones = #{}
  
}