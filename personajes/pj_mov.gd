extends CharacterBody2D

@export var gravedad=475
@export var velocidad=160
@export var salto=300

@onready var animated_skin=$SKIN

func _physics_process(delta: float) -> void:
	# Encontrar la forma de reproducir el 'default' sin alterar las otras animaciones
	if not Input.is_anything_pressed():
		animated_skin.play("default")
		
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
	
	var golpe_presionado=Input.is_action_just_pressed("pegar")
	if golpe_presionado:
		animated_skin.play("pegar")
		
	if not is_on_floor():
		velocity.y=velocity.y + gravedad*delta
	
	move_and_slide()
