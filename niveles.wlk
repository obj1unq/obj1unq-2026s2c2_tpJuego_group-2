import wollok.game.*
import hermanos.*
import caramelos.*
import juego.*

object administradorDeNiveles {
    var property dificultad = 1 
    const fondos = ["1erfondo.jpg", "2dofondo.jpg", "3erfondo.jpg"]
    

    method pasarASiguienteNivel() {
        dificultad = dificultad +1
        game.say(hermanos, "¡Avanzaste al nivel " + dificultad.toString() + "!")

        game.boardGround(fondos.anyOne())
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
