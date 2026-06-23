extends CharacterBody2D

# --- Estados ---
enum State {SPAWN, IDLE, WALK, ATTACK, GET_HIT, DEATH}
var current_state = State.SPAWN

# --- Referencias ---
@onready var sprite = $AnimatedSprite2D

# --- Stats ---
var health = 100
var speed = 60
var attack_range = 50  # distancia a la que ataca
var detect_range = 300  # distancia a la que detecta al player
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	sprite.animation_finished.connect(_on_animation_finished)
	change_state(State.SPAWN)

func _physics_process(_delta):
	match current_state:
		State.IDLE:
			look_for_player()
		State.WALK:
			move_towards_player()
			look_for_player()
		State.ATTACK:
			pass  
		State.GET_HIT:
			pass
		State.DEATH:
			pass
		State.SPAWN:
			pass

# --- Máquina de estados ---
func change_state(new_state: State):
	current_state = new_state
	match new_state:
		State.SPAWN:
			sprite.play("spawn")
		State.IDLE:
			sprite.play("idle")
		State.WALK:
			sprite.play("walk")
		State.ATTACK:
			sprite.play("attack")
		State.GET_HIT:
			sprite.play("get_hit")
		State.DEATH:
			sprite.play("death")

func _on_animation_finished():
	match current_state:
		State.SPAWN:
			change_state(State.IDLE)
		State.ATTACK:
			change_state(State.IDLE)
		State.GET_HIT:
			change_state(State.IDLE)
		State.DEATH:
			queue_free()  # elimina el nodo cuando termina de morir

# --- Lógica de detección y movimiento ---
func look_for_player():
	if player == null:
		return
	var distance = global_position.distance_to(player.global_position)
	if distance <= attack_range:
		if current_state != State.ATTACK:
			change_state(State.ATTACK)
	elif distance <= detect_range:
		if current_state != State.WALK:
			change_state(State.WALK)
	else:
		if current_state != State.IDLE:
			change_state(State.IDLE)

func move_towards_player():
	if player == null:
		return
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	# flip del sprite según dirección horizontal
	sprite.flip_h = direction.x < 0
	move_and_slide()

# --- Recibir daño ---
func take_damage(amount: int):
	if current_state == State.DEATH:
		return
	health -= amount
	if health <= 0:
		change_state(State.DEATH)
	else:
		change_state(State.GET_HIT)
