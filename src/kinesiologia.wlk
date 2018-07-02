//Nota: 4
//test: MB
//1)B Los aparatos quedaron bastantes "tontos", le roba responsabilidad el paciente y hay codigo duplicado por no heredar
//2) B+
//3) Regular-: mucho codigo duplicado
//4) MB

class Paciente{
	var property dolor = null
	var property edad = null
	var property fortaleza = null
	var property rutina = []
	
	method usarAparato(aparato){
		if (self.puedeUsarAparato(aparato)){
		//TODO: pobre uso de polimorfismo: por cada criterio nuevo que quiera modificar un aparato hay
		//que agregar un método nuevo en todos los demás. La mejor solución es 
		// que el aparato reciba una orden y sea éste el que eliga si mandar los mensajes con efecto.
	
		dolor = self.dolor() - aparato.puntosDeDolor(self)
		fortaleza = self.fortaleza() + aparato.puntosDeFortaleza(self)}
		else{
		self.error("No puede usar este aparato")
		}
	}
	
	method puedeUsarAparato(aparato){
		return (aparato.puedeUsarlo(self))
	}
	
	method puedeRealizarSesion(){
		//TODO: Codigo duplicado: si el caso de uso en los test llaman al metodo: paciente.puedeUsarAparato(aparato)
		//Entonces acá el cuerpo del mensaje también tiene que ser self.puedeUsarAparato(aparato)
		return self.rutina().all({aparato => aparato.puedeUsarlo(self)})
	}
	
	method realizarSesionCompleta(){
		if (self.puedeRealizarSesion()){
		self.rutina().forEach({aparato => self.usarAparato(aparato)})
	}
	else
	{
		self.error("No puede realizar la sesion completa")
	}
	}
	
	method cantidadRutinas() = self.rutina().size()
}

class PacienteResistente inherits Paciente{
	override method realizarSesionCompleta(){
		//TODO: innecesario checkeo: llamar a super ya realiza el checkeo y corta el flujo si falla
		//queda codigo duplicado
		//TODO: emprolijar indentacion
		if (self.puedeRealizarSesion()){
		super()
		fortaleza = self.fortaleza() + self.cantidadRutinas()
		}
	else
	{
		self.error("No puede realizar la sesion completa")
	}
}
}

class PacienteCaprichoso inherits Paciente{
		method tieneEnLaRutinaAparatoDeColor(color){
			return self.rutina().any({aparato => aparato.color() == color})
		}
		
		override method puedeRealizarSesion(){
		return super() and self.tieneEnLaRutinaAparatoDeColor("rojo")
	}
		//TODO: innecesario checkeo: llamar a super ya realiza el checkeo y corta el flujo si falla
		//queda codigo duplicado
	
	override method realizarSesionCompleta(){
		if (self.puedeRealizarSesion()){
		super()
		//TODO: código duplicado, este foreach ya está en la superclase 
		self.rutina().forEach({aparato => self.usarAparato(aparato)})
	}
	else
	{
		self.error("No puede realizar la sesion completa")
	}
	}
}

class PacienteRapidaRecuperacion inherits Paciente{
	//TODO: esto no puede ser una variable del objeto, 
	// porque tiene que tener el mismo valor para todos los objetos
	var property recuperacionDolor = 3
	
	method cambiarValorRecuperacion(valor){
		recuperacionDolor = valor
	}
	
	override method realizarSesionCompleta(){
		//TODO Codigo duplicado: usar super()
		if (self.puedeRealizarSesion()){
		//TODO: Codigo duplicado	
		self.rutina().forEach({aparato => self.usarAparato(aparato)})
		dolor = self.dolor() - self.recuperacionDolor() 
	}
	else
	{
		self.error("No puede realizar la sesion completa")
	}
	}
}

class Centro{
	var property aparatos =#{}
	var property pacientes =#{}
	
	method coloresDeAparatos(){
		return	self.aparatos().map({aparato => aparato.color()}).asSet()
	}
	
	method pacientesChiquitos(){
		//TODO: condicion duplicada de si es pequeño con el minitramp
		return	self.pacientes().filter({paciente => paciente.edad() < 8})
	}
	
	method cuantosPacientesNoPuedenCumplirSesion(){
		return	self.pacientes().count({paciente => !paciente.puedeRealizarSesion()})
	}
}

class Magneto{
	//Extraer a una superclase, quedó duplicada la definición y el valor default
	var property color = "blanco"
	
	method puntosDeDolor(paciente) = paciente.dolor() * 10 / 100
	
	method puntosDeFortaleza(paciente) = 0
	
	method puedeUsarlo(paciente) = true
}

class Bicicleta{
	var property color = "blanco"
	
	method puntosDeDolor(paciente) = 4
	
	method puntosDeFortaleza(paciente) = 3
	
	method puedeUsarlo(paciente){ 
		return (paciente.edad() > 8)	
	}
}

class Minitramp{
	var property color = "blanco"
	
	method puntosDeDolor(paciente) = 0
	
	method puntosDeFortaleza(paciente) = paciente.edad() * 10 /100
	
	method puedeUsarlo(paciente){
		//TODO: parentesis innecesarios 
		return (paciente.dolor() < 20)	
	}
}