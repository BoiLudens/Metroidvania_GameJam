extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button2.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().quit()


func _on_button_2_pressed():
	SceneTransition.change_scene_to_file("res://Scenes/menu.tscn")
