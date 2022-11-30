class_name Enemy extends CharacterBody2D

@onready var health_bar = $Health

var health_max: float = 100
var health_value: float = 100 

func take_damage(damage):
	health_value -= damage
	set_health_bar(health_value)
		
func check_death():
	if (health_value <= 0):
		return true

func set_health_bar(health):
	health_bar.value = health_value/health_max * 100
