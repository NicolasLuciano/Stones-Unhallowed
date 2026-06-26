extends CharacterBody2D

@export var speed: int = 200
@export var damage: int = 20
@export var health: int = 20
enum State {IDLE, RUN, ATTACK}
var current_state = State.IDLE
var last_direction = "down"

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Area2D2/Hitbox_attack1
@onready var attack_timer = $Attack_Cooldown

var hitbox_positions = {
	"up":    Vector2(0, -20),
	"down":  Vector2(0, 20),
	"left":  Vector2(-20, 0),
	"right": Vector2(20, 0)
}

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)
	change_state(State.IDLE)

func _on_animation_finished():
	if current_state == State.ATTACK:
		change_state(State.IDLE)

func _physics_process(_delta):
	get_input()
	move_and_slide()
	update_animation()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = speed * input_direction
	if current_state!=State.ATTACK:
		if Input.is_action_just_pressed("action"):
			if attack_timer.is_stopped():
				change_state(State.ATTACK)
	else:
		velocity = Vector2.ZERO #Debe haber una mejor solucion para que cuando ataca no se mueva

func disable_all_hitboxes():
		hitbox.disabled = true

func change_state(new_state: State):
	current_state = new_state
	match new_state:
		State.ATTACK:
			attack_timer.start()
			hitbox.disabled = false
			hitbox.position = hitbox_positions[last_direction]
			sprite.play("attack_1_" + last_direction)
			await get_tree().create_timer(0.15).timeout
			disable_all_hitboxes()
		State.IDLE, State.RUN:
			disable_all_hitboxes()

func update_animation():
	if current_state == State.ATTACK:
		return
	if velocity.length() == 0:
		match last_direction:
			"up":    sprite.play("idle_up")
			"down":  sprite.play("idle_down")
			"left":  sprite.play("idle_left")
			"right": sprite.play("idle_right")
	else:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				last_direction = "right"
				sprite.play("run_right")
			else:
				last_direction = "left"
				sprite.play("run_left")
		else:
			if velocity.y > 0:
				last_direction = "down"
				sprite.play("run_down")
			else:
				last_direction = "up"
				sprite.play("run_up")
