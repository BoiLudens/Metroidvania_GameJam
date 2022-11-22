extends Sprite2D

@onready var health_bar = $Health
var health = 100 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = health
	if (health <= 0):
		print("death")

func take_damage(damage):
	health -= damage
	print("damage taken")
