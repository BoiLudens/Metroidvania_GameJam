extends Enemy

@export var starting_direction : Vector2 = Vector2(0,1)
@export var idle_time : float = .8

@onready var left_ray = $LeftRay
@onready var timer = $Timer
@onready var biker_boss_sprite = $BikerBossSprite
@onready var health_sprite = $Health


const UP = Vector2.UP

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var movement = Vector2()
var speed = 50.0
var start = 50
var stop = 0
var moving_left = true
var idle_count = 0
var change_idle = 0

func _physics_process(delta):
	move()
	
	if left_ray.is_colliding():
		speed = stop
		movement = move_and_slide()
		timer.start(idle_time)
		moving_left = !moving_left
		scale.x = -scale.x
		idle_count += 1
	
	if velocity.x != 0:
		biker_boss_sprite.play("walk")
	
	elif  idle_count <= change_idle:
		biker_boss_sprite.play("idle")
		print(idle_count)
	
	else:
		biker_boss_sprite.play("idle2")
		


func move():
	velocity.y += gravity
	velocity.x = speed if moving_left else -speed
	movement = move_and_slide() 

func _on_timer_timeout():
	speed = start
	move()
