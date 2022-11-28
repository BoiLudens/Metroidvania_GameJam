extends CharacterBody2D

var movement = Vector2()
var speed = 50.0
var start = 50
var stop = 0
var moving_left = true
@export var starting_direction : Vector2 = Vector2(0,1)
@export var idle_time : float = .8


const UP = Vector2.UP
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var left_ray = $left_ray
@onready var timer = $Timer
@onready var walk = $walk
@onready var idle = $idle



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	


	animation_tree.set("parameters/walk/blend_position", starting_direction)

func _physics_process(delta):

	move()
	
	if left_ray.is_colliding():
		
		speed = stop
		movement = move_and_slide()
		walk.visible = not walk.visible
		timer.start(idle_time)
		moving_left = !moving_left
		scale.x = -scale.x
	
		
	
	
	

	


func move():
	
	velocity.y += gravity
	velocity.x = speed if moving_left else -speed
	movement = move_and_slide() 



func _on_timer_timeout():
	idle.visible = not idle.visible
	speed = start
	move()
	
	
