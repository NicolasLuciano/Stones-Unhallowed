extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("izquierda","derecha","arriba","abajo")
	velocity = speed * input_direction

func _physics_process(_delta):
	get_input()
	move_and_slide()
	
