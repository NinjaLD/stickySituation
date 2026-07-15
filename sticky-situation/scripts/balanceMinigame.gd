extends Node2D

@onready var center = $Center
var balanceBarPrefab = preload("res://assets/prefabs/balance_bar.tscn")

# Default
func _ready() -> void:
	BarSpawn()

func process(delta: float) -> void:
	pass

# Custom
func BarSpawn() -> void:
	var balanceBarTemp = balanceBarPrefab.instantiate()
	balanceBarTemp.position.x = 100
	balanceBarTemp.dir = randi_range(0,1) == 0 if -1 else 1
	self.add_child(balanceBarTemp)
