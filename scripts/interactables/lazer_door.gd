extends StaticBody2D

@export var damage_value: int = 20

@onready var hit_box: HitBox = $HitBox
@onready var hurt_box: HurtBox = $HurtBox
@onready var lazer_door_sprite: AnimatedSprite2D = $LazerDoorSprite

var health_max: float = 100
var health_value: float = 100 

# Called when the node enters the scene tree for the first time.
func _ready():
	hit_box.damage = damage_value

func take_damage(damage):
	health_value -= damage
	if check_death():
		hit_box.queue_free()
		hurt_box.queue_free()
		lazer_door_sprite.play("destroyed")
		
func check_death():
	if (health_value <= 0):
		return true
