extends Node2D

@onready var health_clock = $ClockProgressBar
@onready var health_bar = $HorizontalProgressBar

var health_bar_value = 100	

func set_health_bars(health):
	health_clock.value = health
	health_bar.value = health

func _on_player_set_health(health):
	set_health_bars(health)
