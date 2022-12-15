extends Area2D

var entered = false
@export var level_folder: String
@export var level_select: String

func _on_body_entered(body):
	SceneTransition.change_scene_to_file("res://levels/" + level_folder +"/" + level_select + ".tscn")
