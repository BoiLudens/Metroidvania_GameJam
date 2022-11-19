extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Back.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_pressed():
	SceneTransition.change_scene_to_file("res://prefabs/ui/main/main_menu.tscn")


func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_testsfx_pressed():
	$test.play()
	


