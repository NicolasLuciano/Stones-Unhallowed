extends CharacterBody2D

@export var speed: int = 100
@onready var direction : Vector2
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
