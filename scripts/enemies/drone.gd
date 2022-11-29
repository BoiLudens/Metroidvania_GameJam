extends Enemy

@export var health_max_override: float = 200
@export var health_value_override: float = 200

@onready var path_follow: PathFollow2D = self.get_parent()
var move_right: bool = true

func _ready():
	health_value = health_value_override
	health_max = health_value_override
	set_health_bar(health_value)

func _physics_process(delta):
	if (path_follow.progress_ratio + delta) <= 1 and move_right:
		path_follow.progress_ratio += delta
	else:
		move_right = false
	if (path_follow.progress_ratio - delta) >= 0 and !move_right:
		path_follow.progress_ratio -= delta
	else:
		move_right = true
	
