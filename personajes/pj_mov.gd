extends CharacterBody2D

@export var gravedad=475
@export var velocidad=160
@export var salto=300

@onready var animated_skin=$SKIN
@onready var timer_idle=$TimerIdle

var timer_activo=false
var default_animation=false

func _physics_process(delta: float) -> void:
	if not Input.is_anything_pressed() and not default_animation:
		if not timer_activo:
			timer_idle.start()
			timer_activo=true
	
	if Input.is_anything_pressed():
		default_animation=false
		
	var direccion=Input.get_axis("izquierda","derecha")
	velocity.x=velocidad*direccion
	
	if direccion != 0:
		animated_skin.scale.x=direccion	
		if is_on_floor():
			animated_skin.play("caminar")
	
	var salto_presionado=Input.is_action_just_pressed("arriba")
	if salto_presionado and is_on_floor():
		animated_skin.play("salto")
		velocity.y=velocity.y - salto
	
	if not is_on_floor():
		velocity.y=velocity.y + gravedad*delta
		
	var golpe_presionado=Input.is_action_just_pressed("pegar")
	if golpe_presionado:
		animated_skin.play("pegar")
		
	move_and_slide()

# Método que va a accionarse tras la señal emitida por el 'Timer'. La funcion del mismo será reproducir la animación 'default' del personaje luego de haber pasado 1s
func _on_timer_idle_timeout() -> void:
	animated_skin.play("default")
	timer_activo=false
	default_animation=true
	timer_idle.stop()
