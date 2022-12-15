extends CharacterBody2D

@onready var game_manager: Node2D = %GameManager

@onready var sprite_player: AnimatedSprite2D = $PlayerSprite

@onready var dash_timer: Timer = $Timers/DashTimer

@onready var hurt_box: HurtBox = $HurtBox
@onready var hit_box: HitBox = $PlayerSprite/HitBox

enum StateEnum { IDLE, MOVING, ATTACK, DASH }

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed: float = 400.0
var jump_velocity: float = -400.0

var dash_direction: Vector2

var health: int = 100
var whip_damage: int = 20

var state: StateEnum

signal set_health(health)

func _ready():
	dash_direction = Vector2(-sprite_player.scale.x, 0)
	hit_box.set_damage(whip_damage)
	game_manager.checkpoint = position
	emit_signal("set_health", health)
	state = StateEnum.MOVING
	hit_box.monitorable = false

func _physics_process(delta):
	check_death()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	match state:
		StateEnum.IDLE:
			sprite_player.play("idle")
			if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
				pass
			elif Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
				state = StateEnum.MOVING
			elif Input.is_action_just_pressed("action_attack"):
				state = StateEnum.ATTACK
				hit_box.monitorable = true
			elif Input.is_action_just_pressed("action_jump") and is_on_floor():
				velocity.y = jump_velocity
			elif Input.is_action_just_pressed("dash"):
				velocity.x = 0
				state = StateEnum.DASH
		StateEnum.MOVING:
			movement()
		StateEnum.DASH:
			dash()
		StateEnum.ATTACK:
			attack()
	move_and_slide()

func movement():
	sprite_player.play("run")
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	if(velocity.x < 0):
		sprite_player.scale.x = -1
		dash_direction = Vector2(1,0)
	elif(velocity.x > 0):
		sprite_player.scale.x = 1
		dash_direction = Vector2(-1,0)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_just_pressed("action_attack"):
		state = StateEnum.ATTACK
		hit_box.monitorable = true
	elif Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = jump_velocity
	elif Input.is_action_just_pressed("dash"):
		velocity.x = 0
		state = StateEnum.DASH
	elif velocity.x == 0:
		state = StateEnum.IDLE

func attack():
	sprite_player.play("attack")
	if is_on_floor():
		velocity.x = 0
	if attack_timer.time_left == 0:
		attack_timer.start(1)
	

func dash():
	velocity = dash_direction.normalized() * 2500
	if dash_timer.time_left == 0:
		dash_timer.start(0.02)
	

func check_death():
	if (health <= 0):
		position = game_manager.checkpoint
		health = 100
		emit_signal("set_health", health)

func take_damage(damage):
	health -= damage
	emit_signal("set_health", health)

func _on_dash_timer_timeout():
	state = StateEnum.MOVING

func _on_player_sprite_animation_finished():
	state = StateEnum.MOVING
	hit_box.monitorable = false