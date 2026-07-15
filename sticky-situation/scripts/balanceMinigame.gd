extends Node2D

var misses : int
@onready var center = $Center
var balanceBarPrefab = preload("res://assets/prefabs/bar.tscn")

# Default
func _ready() -> void:
	BarSpawn()

func process(delta: float) -> void:
	pass

# Custom
func BarSpawn() -> void:
	var balanceBarTemp = balanceBarPrefab.instantiate()
	balanceBarTemp.dir = 1 if randi_range(0,1) == 0 else -1
	balanceBarTemp.position.x = balanceBarTemp.barDistance * -balanceBarTemp.dir
	self.add_child(balanceBarTemp)

func _on_area_exited(area: Area2D) -> void:
	misses += 1
	print(misses)
	get_tree().queue_delete(area)


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
