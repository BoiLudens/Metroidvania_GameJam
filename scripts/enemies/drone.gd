extends Enemy

@export var health_max_override: float = 200
@export var health_value_override: float = 200

func _ready():
	health_value = health_value_override
	health_max = health_value_override
	set_health_bar(health_value)
