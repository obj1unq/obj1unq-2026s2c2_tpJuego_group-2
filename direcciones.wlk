class Direccion {
  method siguiente(position) {
        self.validarSiguiente(position)
        return self.moverADireccion(position)
    }

    method validarSiguiente(position){
        if(! self.puedeAvanzar(position)){
            self.error("no es posible avanzar")
        }
    }

    method puedeAvanzar(position)
    method moverADireccion(position)
}

class Derecha inherits Direccion {
    override method puedeAvanzar(position) = position.x() < game.width() - 1
    override method moverADireccion(position) = position.right(1)
}

class Izquierda inherits Direccion {
    override method puedeAvanzar(position) = position.x() > 0
    override method moverADireccion(position) = position.left(1)
}

class Arriba inherits Direccion {
    override method puedeAvanzar(position) = position.y() < game.height() - 1
    override method moverADireccion(position) = position.up(1)
}

class Abajo inherits Direccion {
    override method puedeAvanzar(position) = position.y() > 0
    override method moverADireccion(position) = position.down(1)
}