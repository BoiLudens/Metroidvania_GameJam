extends Area2D

var stored_speed
var stored_jump_velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		stored_speed = body.speed
		stored_jump_velocity = body.jump_velocity
		body.speed = 150
		body.jump_velocity = 150


func _on_body_exited(body):
	if body.name == "Player":
		body.speed = stored_speed
		body.jump_velocity = stored_jump_velocity
