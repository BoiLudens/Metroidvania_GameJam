class_name Enemy extends CharacterBody2D

@onready var health_bar = $Health
@onready var death = $Death
var health_max: float = 100
var health_value: float = 100 

func _ready():
	set_health_bar(health_value)
	death.visible = false

func take_damage(damage):
	health_value -= damage
	set_health_bar(health_value)
	if (health_value <= 0):
		death.visible = true
		death.play("death")
		

func set_health_bar(health):
	health_bar.value = health_value/health_max * 100
