extends Enemy

@export var starting_direction: Vector2 = Vector2(0,1)
@export var idle_time: float = .8

@onready var idle_timer: Timer = $Timers/IdleTimer
@onready var detect_timer: Timer = $Timers/DetectTimer
@onready var chase_timer: Timer = $Timers/ChaseTimer

@onready var detection_area = $DetectionArea

@onready var left_ray: RayCast2D = $LeftRay

@onready var gas_mask_sprite: AnimatedSprite2D = $GasMaskSprite
@onready var death: AnimatedSprite2D = $DeathSprite

@onready var hit_box: HitBox = $HitBox

enum StateEnum { IDLE, MOVING, ATTACK}
enum AttackEnum { DEFAULT, DETECTED, CHASE, PUNCH }

const UP = Vector2.UP

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var movement: Vector2 = Vector2()
var speed: float = 50.0
var moving_left: bool = true

var state: StateEnum
var attack_state: AttackEnum
var count = 0

var stop_chase = false

func _ready():
	set_health_bar(health_value)
	death.visible = false
	hit_box.damage = 10
	state = StateEnum.MOVING
	attack_state = AttackEnum.DETECTED

func _physics_process(delta):
	velocity.y += gravity
	
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
			attack()
	move_and_slide()

func move():
	gas_mask_sprite.play("walk")
	velocity.x = speed if moving_left else -speed
	if left_ray.is_colliding():
		moving_left = !moving_left
		scale.x = -scale.x
		state = StateEnum.IDLE
		idle_timer.start(1)

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

func detect(body):
	if body.name == 'Player':
		state = StateEnum.ATTACK
		attack_state = AttackEnum.DETECTED
		detection_area.get_node("CollisionPolygon2D")
		detect_timer.start(1)

func _on_death_sprite_animation_finished():
	queue_free()

func _on_detection_area_body_entered(body):
	detect(body)
	
func _on_idle_timer_timeout():
	state = StateEnum.MOVING

func _on_detect_timer_timeout():
	attack_state = AttackEnum.CHASE

func _on_chase_timer_timeout():
	state = StateEnum.MOVING
	
