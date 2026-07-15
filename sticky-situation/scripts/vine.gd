extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.canClimb = true

func _on_body_exited(body: Node2D) -> void:
	body.canClimb = false
