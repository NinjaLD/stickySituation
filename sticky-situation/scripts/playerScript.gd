extends CharacterBody2D

@export var gravityAccel : float
@export var walkAccel : float
@export var walkSpeed : float
@export var jumpVelocity : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	gravity()
	Walk()
	
	move_and_slide()

func gravity() -> void:
	if not is_on_floor():
		velocity.y += gravityAccel
		print(velocity)

func GetDir() -> float:
	return Input.get_axis("moveLeft", "moveRight")

func Walk() -> void:
	velocity.x *= GetDir() * walkAccel

func Jump() -> void:
	velocity.y = jumpVelocity
