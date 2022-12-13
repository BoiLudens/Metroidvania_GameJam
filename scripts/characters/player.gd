extends CharacterBody2D

@onready var game_manager: Node2D = %GameManager

@onready var sprite_player: AnimatedSprite2D = $PlayerSprite
@onready var sprite_weapon: AnimatedSprite2D = sprite_player.get_node("WeaponSprite")

@onready var animator: AnimationPlayer = $AnimationPlayer

@onready var hurt_box: HurtBox = $HurtBox

enum StateEnum { MOVING, ATTACK, DASH }

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
	sprite_weapon.get_node("HitBox").set_damage(whip_damage)
	game_manager.checkpoint = position
	emit_signal("set_health", health)
	state = StateEnum.MOVING

func _physics_process(delta):
	check_death()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	match state:
		StateEnum.MOVING:
			movement()
		StateEnum.DASH:
			dash()
		StateEnum.ATTACK:
			attack()
	move_and_slide()

func movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
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
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_just_pressed("dash"):
		velocity.x = 0
		state = StateEnum.DASH

func attack():
	if is_on_floor():
		velocity.x = 0
		animator.play("Attack")
	else:
		animator.play("Attack")
	await(get_tree().create_timer(1).timeout)
	state = StateEnum.MOVING

func dash():
	velocity = dash_direction.normalized() * 2500
	await(get_tree().create_timer(.02).timeout)
	state = StateEnum.MOVING

func check_death():
	if (health <= 0):
		position = game_manager.checkpoint
		health = 100
		emit_signal("set_health", health)

func take_damage(damage):
	health -= damage
	emit_signal("set_health", health)
