# Script boceto para lograr la interacción entre personajes
class_name Enemy
extends CharacterBody2D

@onready var animated_sprite=$SKIN

#Flags
var objeto_en_hitbox=false
var idle_animation=false

func _ready() -> void:
	idle_animation=true

func damage_received(damage)->void:
		idle_animation=false
		var msg="¡OUCH! Alguien me pegó %s" % [str(damage)]
		animated_sprite.play("ataque_recibido")
		$TimerIdle.start()
		print(msg)
	
# Método que se va a accionar tras recibir la señal de que fue dañado por un ataque cuerpo a cuerpo(MOMENTANEO, SE PUEDE MEJORAR)
func _on_basic_attack_received(damage: int) -> void:
	if objeto_en_hitbox:
		damage_received(damage)

# Método que va a responder a la señal recibida por la 'HITBOX' cuando un objeto 'Area2D' ingresa en la misma.
func _on_hitbox_area_entered(_area: Area2D) -> void:
	objeto_en_hitbox=true

# Método que va a responder a la señal recibida por la 'HITBOX' cuando un objeto 'Area2D' sale de la misma.
func _on_hitbox_area_exited(_area: Area2D) -> void:
	objeto_en_hitbox=false

# Método que va a accionarse tras la señal emitida por el 'Timer'. La funcion del mismo será reproducir la animación 'default' del personaje luego de haber pasado 1s
func _on_timer_idle_timeout() -> void:
	idle_animation=true
	animated_sprite.play("default")
