extends Enemy

enum StateEnum { 
	IDLE, 
	MOVING, 
	ATTACK}

const LAZER_BOLT = preload("res://prefabs/projectiles/lazer_bolt.tscn")

@export var health_max_override: float = 200
@export var health_value_override: float = 200

@onready var path_follow: PathFollow2D = self.get_parent()
@onready var detection_area = $DetectionArea
@onready var moving_timer = $MovingTimer

var move_right: bool = true
var state
var target
var bullet_speed = 300

func _ready():
	state = StateEnum.MOVING
	health_value = health_value_override
	health_max = health_value_override
	set_health_bar(health_value)

func _physics_process(delta):
	if check_death():
		queue_free()
	match state:
		StateEnum.IDLE:
			pass
		StateEnum.MOVING:
			patrol(delta)
		StateEnum.ATTACK:
			attack()

func patrol(delta) :
	if (path_follow.progress_ratio + delta) <= 1 and move_right:
		path_follow.progress_ratio += delta
	else:
		move_right = false
		detection_area.scale.x = -1
		
	if (path_follow.progress_ratio - delta) >= 0 and !move_right:
		path_follow.progress_ratio -= delta
	else:
		move_right = true
		detection_area.scale.x = 1

func attack():
	var lazer_bolt = LAZER_BOLT.instantiate()
	get_node("/root").add_child(lazer_bolt)
	lazer_bolt.position = global_position
	lazer_bolt.look_at(target)
	lazer_bolt.apply_impulse(Vector2(bullet_speed, 0).rotated(lazer_bolt.rotation), Vector2())
	
	state = StateEnum.IDLE
	moving_timer.start()
	
func _on_detection_area_body_entered(body):
	if body.name == "Player":
		target = body.position
		state = StateEnum.ATTACK

func _on_moving_timer_timeout():
	state = StateEnum.MOVING
