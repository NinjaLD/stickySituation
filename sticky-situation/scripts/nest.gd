extends Node2D
@onready var player = $"../../Player"

func _on_area_2d_body_entered(body: Node2D) -> void:
	player.won = true
