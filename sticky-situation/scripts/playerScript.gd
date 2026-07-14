extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@export var gravityAccel : int
@export var walkAccel : int
@export var walkSpeed : int
@export var decceleration : int
@export var jumpVelocity : Vector2
var potentialVelocity : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	gravity()
	if is_on_floor():
		Walk()
	Jump()
	Animation()
	AnimationDirection()
	
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

#Changed the jump value to be lower so the charge has a bigger effect
func Jump(delta) -> void:
	if Input.is_action_pressed("jump") and is_on_floor():
		print("The player is charging their jump")
		potentialVelocity += 10 * delta
		print(potentialVelocity)
	if Input.is_action_just_released("jump") and is_on_floor():
		print("the player will jump now")
		velocity.y = -jumpVelocity.y
		velocity.x += jumpVelocity.x * velocity.x # change to be for hold jump is mor boing boing
		print(velocity)
		print(jumpVelocity.y)

#Plays character animations relative to what they are doing
func Animation() -> void:
	if is_on_floor():
		if GetInputDir() == 0:
			animatedSprite.play("Idle")
		else:
			animatedSprite.play("Walk")
	else:
		animatedSprite.play("Jump")

#Flips the sprite depending on the direction they are going
func AnimationDirection() -> void:
	if GetInputDir() < 0 and velocity.x < 0:
		animatedSprite.flip_h = true
	elif GetInputDir() > 0 and velocity.x > 0:
		animatedSprite.flip_h = false
