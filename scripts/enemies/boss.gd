extends Enemy

@export var starting_direction : Vector2 = Vector2(0,1)
@export var idle_time : float = 3


@onready var left_ray = $LeftRay
@onready var timer = $Timer
@onready var biker_boss_sprite = $BikerBossSprite
@onready var death = $DeathSprite

enum StateEnum { IDLE, MOVING, ATTACK }

const UP = Vector2.UP

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var movement = Vector2()
var speed = 50.0
var moving_left = true

var state
var animation_array
var animation_string

func _ready():
	set_health_bar(health_value)
	death.visible = false
	animation_array = ["idle", "idle2"]
	state = StateEnum.MOVING

func _physics_process(delta):
	if check_death():
		biker_boss_sprite.visible = false
		death.visible = true
		death.play("death")
		
	match state:
		StateEnum.IDLE:
			biker_boss_sprite.play(animation_string)
		StateEnum.MOVING:
			move()
		StateEnum.ATTACK:
			pass

func move():
	velocity.y += gravity
	velocity.x = speed if moving_left else -speed
	if left_ray.is_colliding():
		timer.start(idle_time)
		moving_left = !moving_left
		scale.x = -scale.x
		animation_string = animation_array.pick_random()
		state = StateEnum.IDLE
	if velocity.x != 0:
		biker_boss_sprite.play("walk")
	move_and_slide()
	

func _on_timer_timeout():
	state = StateEnum.MOVING

func _on_death_sprite_animation_finished():
	queue_free()
