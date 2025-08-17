# Script boceto para lograr la interacción entre personajes
extends CharacterBody2D

var enemigo_alcance=false

# Método que va a modificar la flag 'enemigo_alcance' a True cuando reciba la señal de que un cuerpo ingresó a la hitbox del personaje, indicando asi que el mismo es vulnerable a cualquier ataque del enemigo.
#EXTRA: 'body' además de 'Personaje' puede ser del tipo 'Ataque' simbolizando asi los ataques especiales
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Personaje:
		enemigo_alcance=true

# Método que va a modificar la flag 'enemigo_alcance' a False cuando reciba la señal de que un cuerpo salió la hitbox del personaje, indicando que el mismo no va a poder recibir ataques que lo puedan dañar.
#EXTRA: 'body' además de 'Personaje' puede ser del tipo 'Ataque' simbolizando asi los ataques especiales
func _on_hitbox_body_exited(body: Node2D) -> void:
	if body is Personaje:
		enemigo_alcance=false

# Método que se va a accionar tras recibir la señal de que fue dañado. La misma solo va a ser aceptable si un enemigo ingresó en su hitbox.
func _on_attack_receibed(damage: int) -> void:
	if enemigo_alcance:
		var msg="¡OUCH! Alguien me pegó %s" % [str(damage)]
		print(msg)
