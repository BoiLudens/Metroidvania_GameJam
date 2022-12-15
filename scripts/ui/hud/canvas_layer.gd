extends CanvasLayer

@onready var health_bar = $"Health Bar"

func _ready():
	var player = get_tree().get_first_node_in_group("players")
	player.connect("set_health", health_bar._on_player_set_health)