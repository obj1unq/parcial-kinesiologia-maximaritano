class Paciente{
	var property dolor = null
	var property edad = null
	var property fortaleza = null
	var property rutina = []
	
	method usarAparato(aparato){
		if (self.puedeUsarAparato(aparato)){
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
	
	override method realizarSesionCompleta(){
		if (self.puedeRealizarSesion()){
		super()
		self.rutina().forEach({aparato => self.usarAparato(aparato)})
	}
	else
	{
		self.error("No puede realizar la sesion completa")
	}
	}
}

class PacienteRapidaRecuperacion inherits Paciente{
	var property recuperacionDolor = 3
	
	method cambiarValorRecuperacion(valor){
		recuperacionDolor = valor
	}
	
	override method realizarSesionCompleta(){
		if (self.puedeRealizarSesion()){
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
		return	self.pacientes().filter({paciente => paciente.edad() < 8})
	}
	
	method cuantosPacientesNoPuedenCumplirSesion(){
		return	self.pacientes().count({paciente => !paciente.puedeRealizarSesion()})
	}
}

class Magneto{
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
		return (paciente.dolor() < 20)	
	}
}