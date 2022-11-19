extends Node2D

@onready var health_clock = $ClockProgressBar
@onready var health_bar = $HorizontalProgressBar

var health_bar_value = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health_bars(health_bar_value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_health_bars(health):
	health_clock.value = health
	health_bar.value = health

func _on_player_hit(health_bar_value):
	set_health_bars(health_bar_value)
