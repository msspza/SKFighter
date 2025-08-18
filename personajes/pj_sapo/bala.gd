class_name Ataque
extends Area2D

@onready var animated_sprite=$SKIN

@export var velocidad_bala=275
var damage_attack=100

func _process(_delta: float) -> void:
	if position.x > 1000:
		queue_free()

func _physics_process(delta: float) -> void:
	position.x += velocidad_bala * delta

# Método que se va a disparar cuando la HITBOX de la bala emita una señal que indicará que la misma entro en contacto con otro cuerpo
func _on_body_contact_bullet(body: Node2D) -> void:
	if body is Enemy and body.has_method("damage_received"):
		body.damage_received(damage_attack)
		velocidad_bala=0
		animated_sprite.play("destruccion")

# Método que se va a ejecutar al recibir la señal de que la animacion de la bala denominada 'destruccion' finalice
func _on_skin_animation_finished() -> void:
	if animated_sprite.animation == "destruccion":
		queue_free()
