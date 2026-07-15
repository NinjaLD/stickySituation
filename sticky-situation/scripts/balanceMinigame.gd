extends Node2D

var spawns : int
@export var spawnsRange : Vector2
@export var count : int
@onready var center = $Center
var balanceBarPrefab = preload("res://assets/prefabs/bar.tscn")
var touchingLeft : int
var touchingRight : int
var timer

# Default
func _ready() -> void:
	spawns = randi_range(spawnsRange.x, spawnsRange.y)
	SpawnTimer()

func _process(delta: float) -> void:
	KeyPress()
	if count == 0:
		self.queue_free() # Fail Loser
	if spawns == 0:
		var anotherTimer = Timer.new()
		anotherTimer.wait_time = 2
		self.add_child(anotherTimer)
		anotherTimer.start()
		anotherTimer.timeout.connect(_on_another_timer_timeout)

func _on_area_entered(area: Area2D) -> void:
	if area.dir == 1:
		touchingLeft += 1
	if area.dir == -1:
		touchingRight += 1

func _on_area_exited(area: Area2D) -> void:
	count -=1
	if area.dir == 1:
		touchingLeft = 0
	if area.dir == -1:
		touchingRight = 0
	get_tree().queue_delete(area)

func _on_timer_timeout() -> void:
	BarSpawn()
	SpawnTimer()
	get_tree().queue_delete(timer)

func _on_another_timer_timeout() -> void:
	self.queue_free() # stay on vine

# Custom
func SpawnTimer() -> void:
	timer = Timer.new()
	timer.wait_time = randf_range(0.5, 1.5)
	self.add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func BarSpawn() -> void:
	if spawns > 0:
		var balanceBarTemp = balanceBarPrefab.instantiate()
		balanceBarTemp.dir = 1 if randi_range(0,1) == 0 else -1
		balanceBarTemp.position.x = balanceBarTemp.barDistance * -balanceBarTemp.dir
		self.add_child(balanceBarTemp)
		spawns -= 1

func KeyPress() -> void:
	if Input.is_action_just_pressed("balanceLeft"):
		if touchingLeft > 0:
			touchingLeft = 0
			count += 1
		else:
			count -= 1
	if Input.is_action_just_pressed("balanceRight"):
		if touchingRight > 0:
			touchingRight = 0
			count += 1
		else:
			count -= 1
