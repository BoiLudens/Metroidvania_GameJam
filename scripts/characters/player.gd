extends CharacterBody2D

@onready var game_manager = %GameManager
@onready var sprite_player = $PlayerSprite
@onready var sprite_weapon = sprite_player.get_node("WeaponSprite")
@onready var animator = $AnimationPlayer
@onready var hurt_box = $HurtBox

const SPEED = 400.0
const JUMP_VELOCITY = -400.0

#dash
var dash_direction = Vector2(1,0)
var can_dash = false
var dashing = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var whip_damage = 20

signal set_health(health)

func _ready():
	emit_signal("set_health", health)
	sprite_weapon.get_node("HitBox").set_damage(whip_damage)

func _process(delta):
	check_death()
	if Input.is_action_just_pressed("action_attack"):
		animator.play("Attack")

func _physics_process(delta):
	dash()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		can_dash = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		
		if(velocity.x < 0):
			sprite_player.scale.x = -1
		elif(velocity.x > 0):
			sprite_player.scale.x = 1

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#dash
func dash():
	if is_on_floor():
		can_dash = true
	
	if Input.is_action_pressed("ui_right"):
		dash_direction = Vector2(1,0)
	if Input.is_action_pressed("ui_left"):
		dash_direction = Vector2(-1,0)
		
	if Input.is_action_just_pressed("dash") and can_dash:
		velocity = dash_direction.normalized() * 2000
		can_dash = false
		dashing = true
		await(get_tree().create_timer(0.2).timeout)
		dashing = false
	

func check_death():
	if (health <= 0):
		position = game_manager.checkpoint
		health = 100

func take_damage(damage):
	health -= damage
	emit_signal("set_health", health)
