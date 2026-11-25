import wollok.game.*
import juego.*
import ladronYArbusto.*
import caramelos.*
import hermanos.*

class Direccion {
 method siguiente(position) {
   const candidata = self._siguiente(position)
   self.validarSiguiente(candidata)
   return candidata
 }
 method _siguiente(position)


 method validarSiguiente(position) {
   if (not self.puedeIr(position)) {
     self.error("No se puede ir a ahí")
   }
 }
 method puedeIr(position) {
   return self.dentroDelTablero(position) and self.libreDeSolidos(position)
 }
 method dentroDelTablero(position) {
   return position.x().between(0, game.width()-1) and position.y().between(0, game.height() -1 )
 }
 method libreDeSolidos(position) {
   return not game.getObjectsIn(position).any({visual => visual.solido()})
 }


}
class Arriba inherits Direccion{
 override method _siguiente(position) {
   return position.up(1)
 }


}


class Abajo inherits Direccion {
 override method _siguiente(position) {
   return position.down(1)
 }
}
class Derecha inherits Direccion{
 override method _siguiente(position) {
   return position.right(1)
 }
}

class Izquierda inherits Direccion{
 override method _siguiente(position) {
   return position.left(1)
 }
}



class BosqueSolido inherits Visual {
  override method image() = "solido.png"
  override method solido() = true
}

