extends CharacterBody2D

@export var starting_direction : Vector2 = Vector2(0,1)
@export var idle_time : float = 3
@export var health_max: float = 100
@export var health_value: float = 100 

@onready var idle_timer: Timer = $Timers/IdleTimer
@onready var detect_timer: Timer = $Timers/DetectTimer
@onready var chase_timer: Timer = $Timers/ChaseTimer

@onready var left_ray: RayCast2D = $LeftRay

@onready var biker_boss_sprite: AnimatedSprite2D = $BikerBossSprite
@onready var death: AnimatedSprite2D = $DeathSprite
@onready var health_bar = $Health

@onready var hit_box: HitBox = $HitBox

enum StateEnum { IDLE, MOVING, ATTACK }
enum AttackEnum { DEFAULT, DETECTED, CHASE, PUNCH }

const UP: Vector2 = Vector2.UP

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var movement: Vector2 = Vector2()
var speed: float = 50.0
var moving_left: bool = true

var state: StateEnum
var attack_state: AttackEnum
var animation_array: Array[String]
var animation_string: String



func _ready():
	set_health_bar(health_value)
	death.visible = false
	hit_box.damage = 10
	animation_array = ["idle", "idle2"]
	state = StateEnum.MOVING

func _physics_process(delta):
	velocity.y += gravity
	if check_death():
		die()
		
	match state:
		StateEnum.IDLE:
			biker_boss_sprite.play(animation_string)
		StateEnum.MOVING:
			move()
		StateEnum.ATTACK:
			attack()
	move_and_slide()

func attack():
	if left_ray.is_colliding():
		if left_ray.get_collider().get("name") == 'Player':
			attack_state = AttackEnum.PUNCH
	match attack_state:
		AttackEnum.DETECTED:
			velocity.x = 0
		AttackEnum.CHASE:
			velocity.x = (speed * 5) if moving_left else (-speed * 5)
			if velocity.x != 0 and left_ray.is_colliding():
				state = StateEnum.MOVING
		AttackEnum.PUNCH:
			state = StateEnum.MOVING

func move():
	biker_boss_sprite.play("walk")
	velocity.x = speed if moving_left else -speed
	if left_ray.is_colliding():
		moving_left = !moving_left
		scale.x = -scale.x
		animation_string = animation_array.pick_random()
		state = StateEnum.IDLE
		idle_timer.start(idle_time)
	

func detect(body):
	if body.name == 'Player':
		state = StateEnum.ATTACK
		attack_state = AttackEnum.DETECTED
		detect_timer.start(1)
		
func die():
	biker_boss_sprite.visible = false
	death.visible = true
	death.play("death")
	SceneTransition.change_scene_to_file("res://levels/end.tscn")

func take_damage(damage):
	health_value -= damage
	set_health_bar(health_value)
		
func check_death():
	if (health_value <= 0):
		return true

func set_health_bar(health):
	health_bar.value = health_value/health_max * 100

# Last minute change so that scene transition is bug free
# func _on_death_sprite_animation_finished():
# 	queue_free()

func _on_detection_area_body_entered(body):
	detect(body)

func _on_idle_timer_timeout():
	state = StateEnum.MOVING

func _on_detect_timer_timeout():
	attack_state = AttackEnum.CHASE

func _on_chase_timer_timeout():
	state = StateEnum.MOVING
