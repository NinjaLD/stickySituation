extends Area2D

@onready var animatedLeaf = $Leaf

func _on_body_entered(body: Node2D) -> void:
	body.Bounce(self.rotation)
	
func _physics_process(delta: float) -> void:
	animatedLeaf.play("leafBouncing")
