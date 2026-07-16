extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if get_tree().current_scene.name == "Tutorial":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game.tscn")
	if get_tree().current_scene.name == "Game":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/win.tscn")
