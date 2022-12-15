extends Area2D

@export var level_folder: String
@export var level_select: String

func _on_body_entered(body):
	if body.name == "Player":
		SceneTransition.change_scene_to_file("res://levels/" + level_folder +"/" + level_select + ".tscn")