extends CharacterBody2D

@export var gravityAccel : int
@export var walkAccel : int
@export var walkSpeed : int
@export var decceleration : int
@export var jumpVelocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	gravity()
	if is_on_floor():
		Walk()
	Jump()
	
	move_and_slide()

func gravity() -> void:
	if not is_on_floor():
		velocity.y += gravityAccel

func GetInputDir() -> float:
	return Input.get_axis("moveLeft", "moveRight")

func Walk() -> void:
	var velocityDir
	if velocity.x > 0:
		velocityDir = 1
	elif velocity.x < 0:
		velocityDir = -1
	else:
		velocityDir = 0
	
	if GetInputDir() == 0:
		velocity.x = maxf(abs(velocity.x) - decceleration, 0) * velocityDir
		pass
	else:
		velocity.x = clampf(velocity.x + GetInputDir() * walkAccel, -walkSpeed, walkSpeed)

func Jump() -> void:
	if Input.is_action_pressed("jump") and is_on_floor():
		print("The player is charging their jump")
		# change the jump velocities
	if Input.is_action_just_released("jump") and is_on_floor():
		print("the player will jump now")
		velocity.y = -jumpVelocity.y
		velocity.x += jumpVelocity.x * velocity.x # change to be for hold jump is mor boing boing
		print(velocity)
