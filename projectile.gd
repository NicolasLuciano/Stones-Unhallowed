extends CharacterBody2D

@export var speed: int = 300
@onready var direction : Vector2
@onready var first_position : Vector2
@onready var timer = $Timer
@onready var player_area : Area2D = get_tree().get_first_node_in_group("player_area")
@export var damage : int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = first_position
	look_at(global_position + direction)
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == player_area:
		queue_free()
