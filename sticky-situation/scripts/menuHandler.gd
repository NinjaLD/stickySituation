extends Node

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_level_testing_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/layoutTemp.tscn")

func _on_player_development_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/playerDevelopment.tscn")
