extends CharacterBody2D

var movement = Vector2()
var speed = 50.0
var moving_left = true
@export var starting_direction : Vector2 = Vector2(0,1)

const UP = Vector2.UP
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var left_ray = $left_ray



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():


	animation_tree.set("parameters/walk/blend_position", starting_direction)

func _physics_process(delta):

	move()

	if left_ray.is_colliding():
		moving_left = !moving_left
		scale.x = -scale.x
	
	
	

func move():
	
	velocity.y += gravity
	velocity.x = speed if moving_left else -speed
	movement = move_and_slide() 

