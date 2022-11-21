extends CharacterBody2D

@onready var game_manager = %GameManager
@onready var animated_sprite: AnimatedSprite2D = $PlayerSprite
@onready var animated_weapon: AnimatedSprite2D = animated_sprite.get_node("WeaponSprite")
@onready var hurt_box = $HurtBox

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100

signal set_health(health)

func _ready():
	emit_signal("set_health", health)

func _process(delta):
	check_death()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("action_attack"):
		animated_weapon.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		
		if(velocity.x < 0):
			animated_sprite.scale.x = -1
		elif(velocity.x > 0):
			animated_sprite.scale.x = 1

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func check_death():
	if (health <= 0):
		position = game_manager.checkpoint
		health = 100

func take_damage(damage):
	health -= damage
	emit_signal("set_health", health)
