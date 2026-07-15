extends Sprite2D

@export var speed : int
@export var barDistance : int
var dir : int

func _process(delta: float) -> void:
	Move(delta)

func Move(deltaTime) -> void:
	position.x += speed * dir * deltaTime
