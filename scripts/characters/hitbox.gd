extends Area2D

signal hit_player


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hurt_player(damage):
	emit_signal("hurt_player")
	
