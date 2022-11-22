extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0

#dash
var dash_direction = Vector2(1,0)
var can_dash = false
var dashing = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal set_health(health)

@onready var animated_sprite = $AnimatedSprite2D
var health = 100

func _ready():
	emit_signal("set_health", health)

func _physics_process(delta):
	dash()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		can_dash = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
		if(velocity.x < 0):
			animated_sprite.flip_h = true
		elif(velocity.x > 0):
			animated_sprite.flip_h = false
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
	

func _on_hit_box_area_entered(area):
	if (area.name == "Hurt Box"):
		health -= area.damage
		emit_signal("set_health", health)
