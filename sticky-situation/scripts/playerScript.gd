extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@export var gravityAccel : int
@export var walkAccel : int
@export var walkSpeed : int
@export var decceleration : int
#@export var jumpVelocity : Vector2
@export var jumpChargeRate : float
@export var jumpVelBoostY : Vector2
@export var jumpVelBoostX : Vector2
@export var maxVineVelocity : int
@export var climbSpeed : int

var potentialVelocity : float
var canClimb : bool

# Automatic
func _physics_process(delta: float) -> void:
	gravity()
	if is_on_floor() or canClimb:
		Walk()
	Jump()
	Climb()
	Animation()
	AnimationDirection()
	
	move_and_slide()

# Custom
func gravity() -> void:
	if not is_on_floor() and not canClimb:
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

func Jump() -> void:
	if Input.is_action_pressed("jump") and is_on_floor():
		potentialVelocity = minf(potentialVelocity + jumpChargeRate, 1)
	if Input.is_action_just_released("jump") and is_on_floor():
		velocity.y = -(jumpVelBoostY.x + (jumpVelBoostY.y - jumpVelBoostY.x) * potentialVelocity)
		velocity.x += (jumpVelBoostX.x + (jumpVelBoostX.y - jumpVelBoostX.x) * potentialVelocity) * (velocity.x / walkSpeed)
		
		potentialVelocity = 0

func Bounce() -> void:
	pass

func Climb() -> void:
	if Input.is_action_pressed("climb") and canClimb == true:
		velocity.y = -climbSpeed
		if velocity.x > maxVineVelocity:
			velocity.x = maxVineVelocity
		elif velocity.x < -maxVineVelocity:
			velocity.x = -maxVineVelocity
	elif canClimb == true:
		velocity.y = 0
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
