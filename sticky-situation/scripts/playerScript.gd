extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@export var gravityAccel : int
@export var walkAccel : int
@export var walkSpeed : int
@export var decceleration : int
#@export var jumpVelocity : Vector2
@export var minVerticalVelocity : int
@export var maxVerticalVelocity : int

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

func GetVelocityDir() -> int:
	var velocityDir
	if velocity.x > 0:
		velocityDir = 1
	elif velocity.x < 0:
		velocityDir = -1
	else:
		velocityDir = 0
	
	return velocityDir

func Walk() -> void:
	
	if GetInputDir() == 0:
		velocity.x = maxf(abs(velocity.x) - decceleration, 0) * GetVelocityDir()
		pass 
	else:
		velocity.x = clampf(velocity.x + GetInputDir() * walkAccel, -walkSpeed, walkSpeed)

#Changed the jump value to be lower so the charge has a bigger effect
#Wanting to add velocityDir to be part of the function so we can check for direction for horizontal boost
func Jump() -> void:
	if Input.is_action_pressed("jump") and is_on_floor():
		#Charges the players' potential velocity every tick by 10
		potentialVelocity += 10
	if Input.is_action_just_released("jump") and is_on_floor():
		#Set a maxVerticalVelocity to stop the player from jumping insanely high (is set as a var)
		#This is the min vertical velocity + the potentialVelocity (charge) which goes up to at most the max velocity
		velocity.y = maxf(-(minVerticalVelocity + potentialVelocity), -maxVerticalVelocity)
		potentialVelocity = 0
		velocity.x += 200 * GetVelocityDir()

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
