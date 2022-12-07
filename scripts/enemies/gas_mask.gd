extends Enemy

@export var starting_direction : Vector2 = Vector2(0,1)
@export var idle_time : float = .8

@onready var left_ray = $LeftRay
@onready var timer = $Timer
@onready var gas_mask_sprite = $GasMaskSprite
@onready var death = $DeathSprite

enum StateEnum { IDLE, MOVING, ATTACK}

const UP = Vector2.UP

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var movement = Vector2()
var speed = 50.0
var moving_left = true

var state

func _ready():
	set_health_bar(health_value)
	death.visible = false
	state = StateEnum.MOVING

func _physics_process(delta):
	if check_death():
		gas_mask_sprite.visible = false
		death.visible = true
		death.play("death")
		
	match state:
		StateEnum.IDLE:
			gas_mask_sprite.play("idle")
		StateEnum.MOVING:
			move()
		StateEnum.ATTACK:
			pass

func move():
	velocity.y += gravity
	velocity.x = speed if moving_left else -speed
	
	if left_ray.is_colliding():
		moving_left = !moving_left
		scale.x = -scale.x
		state = StateEnum.IDLE
		timer.start(idle_time)
	if velocity.x != 0:
		gas_mask_sprite.play("walk")
	move_and_slide()

func _on_timer_timeout():
	state = StateEnum.MOVING

func _on_death_sprite_animation_finished():
	queue_free()
