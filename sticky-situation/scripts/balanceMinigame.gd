extends Node2D

var count : int = 3
@onready var center = $Center
var balanceBarPrefab = preload("res://assets/prefabs/bar.tscn")
var touchingLeft : int
var touchingRight : int

# Default
func _ready() -> void:
	BarSpawn()

func _process(delta: float) -> void:
	KeyPress()

func _on_area_entered(area: Area2D) -> void:
	if area.dir == 1:
		touchingLeft += 1
	if area.dir == -1:
		touchingRight += 1

func _on_area_exited(area: Area2D) -> void:
	count -=1
	if area.dir == 1:
		touchingLeft -= 1
	if area.dir == -1:
		touchingRight -= 1
	print(count)
	get_tree().queue_delete(area)

# Custom
func BarSpawn() -> void:
	var balanceBarTemp = balanceBarPrefab.instantiate()
	balanceBarTemp.dir = 1 if randi_range(0,1) == 0 else -1
	balanceBarTemp.position.x = balanceBarTemp.barDistance * -balanceBarTemp.dir
	self.add_child(balanceBarTemp)

func KeyPress() -> void:
	if Input.is_action_just_pressed("balanceLeft"):
		if touchingLeft > 0:
			touchingLeft -= 1
			count += 1
		else:
			count -= 1
		print(count)
	if Input.is_action_just_pressed("balanceRight"):
		if touchingRight > 0:
			touchingRight -= 1
			count += 1
		else:
			count -= 1
		print(count)
