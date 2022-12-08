extends Area2D

var entered = false

func _on_body_entered(body):
	print("entered")
	entered = true
	

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("Door"):
			SceneTransition.change_scene_to_file("res://levels/Level_1/level_1.2.tscn")



