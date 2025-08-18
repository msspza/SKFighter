#Script boceto para los movimientos y ataques de los personajes
#¿Hacer un script por personaje?Investigar la posibilidad de que un nodo tenga multiples scripts
class_name Personaje
extends CharacterBody2D

signal basic_attack(damage:int)

@export var gravedad=475

@export var velocidad=160
@export var salto=300
@export var basic_damage=25

@onready var animated_skin=$SKIN
@onready var timer_idle=$TimerIdle

const ESCENA_Q_SAPO=preload("res://personajes/pj_sapo/HabilidadA.tscn")

# Flags
var timer_q_cooldown=false
var timer_idle_animation=false
var idle_animation=false
	
func _physics_process(delta: float) -> void:
	if not Input.is_anything_pressed() and not idle_animation:
		if not timer_idle_animation:
			timer_idle.start()
			timer_idle_animation=true
	
	if Input.is_anything_pressed():
		idle_animation=false
		
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
	
	########## Bloque de ataques ################
	var basico_presionado=Input.is_action_just_pressed("pegar")
	if basico_presionado:
		animated_skin.play("pegar")
		basic_attack.emit(basic_damage)
	
	var habilidad_a=Input.is_action_just_pressed("primera_habilidad")
	if habilidad_a and not timer_q_cooldown:
		timer_q_cooldown=true
		$CooldownQ.start()
		
		var bala=ESCENA_Q_SAPO.instantiate()
		get_parent().add_child(bala)
		
		bala.global_position=$SpawnSkillA.global_position
		bala.scale.x*=animated_skin.scale.x
		bala.velocidad_bala*=animated_skin.scale.x
		
	move_and_slide()

# Método que va a accionarse tras la señal emitida por el 'Timer'. La funcion del mismo será reproducir la animación 'default' del personaje luego de haber pasado 1s
func _on_timer_idle_timeout() -> void:
	animated_skin.play("default")
	timer_idle_animation=false
	idle_animation=true
	timer_idle.stop()

# Método que va a recibir la señal del timer que simboliza el cooldown de la habilidad 'Q'
func _on_cooldown_q_timeout() -> void:
	if timer_q_cooldown:
		timer_q_cooldown=false
