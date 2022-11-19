extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Start.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	SceneTransition.change_scene_to_file("res://levels/debug_land.tscn")


func _on_options_pressed():
	SceneTransition.change_scene_to_file("res://Menus/options/options.tscn")


func _on_quit_pressed():
	get_tree().quit()
