extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if get_tree().current_scene.name == "tutorial":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game.tscn")
	if get_tree().current_scene.name == "game":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game.tscn")
		pass
