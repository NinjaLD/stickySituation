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
	balanceBarTemp.dir = 1 if randi_range(0,1) == 0 else -1
	balanceBarTemp.position.x = balanceBarTemp.barDistance * -balanceBarTemp.dir
	self.add_child(balanceBarTemp)
