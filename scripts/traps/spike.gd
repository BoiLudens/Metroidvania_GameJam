extends Node2D

signal hurt_player(damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hurt_box_area_entered(area):
	print(area.name)
	if (area.name == "HitBox"):
		emit_signal("hurt_player", 10)
