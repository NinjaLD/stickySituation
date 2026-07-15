extends CharacterBody2D

var minigamePrefab = preload("res://assets/prefabs/balance_minigame.tscn")
@onready var animatedSprite = $AnimatedSprite2D
@export var gravityAccel : int
@export var walkAccel : int
@export var walkSpeed : int
@export var decceleration : int
@export var jumpChargeRate : float
@export var jumpVelBoostY : Vector2
@export var jumpVelBoostX : Vector2
@export var maxVineVelocity : int
@export var climbSpeed : int
@export var leafBounceMult : int
@export var minigameSpawnRate : int
@export var minigameSpawnChance : int # 100 / value, e.g. if value is 4, chance is 100/4 or 25%

var potentialVelocity : float
var vinesIn : int
var vineWalking : bool
var isInMinigame : bool
var timer
var minigameTrigger : int

# Automatic
func _physics_process(delta: float) -> void:
	Gravity()
	if is_on_floor() or vinesIn >= 1:
		Walk()
	Jump()
	Climb()
	vineWalker()
	InMinigame()
	Animation()
	AnimationDirection()
	Cheat()
	
	move_and_slide()

# Custom
func Gravity() -> void:
	if not is_on_floor() and vinesIn <= 0:
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

func InMinigame() -> void:
	if vineWalking and minigameTrigger == 0 and not isInMinigame:
		timer = Timer.new()
		timer.wait_time = minigameSpawnRate
		self.add_child(timer)
		timer.start()
		timer.timeout.connect(_on_timer_timeout)
		minigameTrigger = 1
	if isInMinigame == true:
		Immovable()

func _on_timer_timeout() -> void:
	var spawnChance = randi_range(0, 1)
	if spawnChance == 1 and vineWalking:
		var minigame = minigamePrefab.instantiate()
		self.add_child(minigame)
	minigameTrigger = 0
	get_tree().queue_delete(timer)

func Immovable() -> void:
	if velocity.x != 0:
		velocity.x = 0
	if velocity.y != 0:
		velocity.y = 0

func Walk() -> void:
	if GetInputDir() == 0:
		velocity.x = maxf(abs(velocity.x) - decceleration, 0) * GetVelocityDir()
	else:
		velocity.x = clampf(velocity.x + GetInputDir() * walkAccel, -walkSpeed, walkSpeed)

func Jump() -> void:
	if Input.is_action_pressed("jump") and is_on_floor() and not vineWalking:
		potentialVelocity = minf(potentialVelocity + jumpChargeRate, 1)
	if Input.is_action_just_released("jump") and is_on_floor() and not vineWalking:
		velocity.y = -(jumpVelBoostY.x + (jumpVelBoostY.y - jumpVelBoostY.x) * potentialVelocity)
		velocity.x += (jumpVelBoostX.x + (jumpVelBoostX.y - jumpVelBoostX.x) * potentialVelocity) * (velocity.x / walkSpeed)
		
		potentialVelocity = 0

func vineWalker() -> void:
	if vineWalking:
		isOnVine()

func Bounce(leafDir) -> void:
	velocity.y = leafBounceMult * -sin(leafDir + deg_to_rad(90))
	velocity.x = leafBounceMult * -cos(leafDir + deg_to_rad(90)) - velocity.x / 10

func isOnVine() -> void:
	if velocity.x > maxVineVelocity:
		velocity.x = maxVineVelocity
	elif velocity.x < -maxVineVelocity:
		velocity.x = -maxVineVelocity

func Climb() -> void:
	if Input.is_action_pressed("climb") and vinesIn >= 1:
		animatedSprite.play("Climb")
		velocity.y = -climbSpeed
		isOnVine()
	elif Input.is_action_pressed("descend") and vinesIn >= 1:
		animatedSprite.play("Climb")
		velocity.y = climbSpeed
		isOnVine()
	elif vinesIn >= 1:
		velocity.y = 0
		isOnVine()

#Plays character animations relative to what they are doing
func Animation() -> void:
	if is_on_floor():
		if vineWalking:
			animatedSprite.play("OnVine")
		elif GetInputDir() == 0:
			animatedSprite.play("Idle")
		else:
			animatedSprite.play("Walk")
	elif vinesIn <= 0:
		animatedSprite.play("Jump")


#Flips the sprite depending on the direction they are going
func AnimationDirection() -> void:
	if vinesIn <= 0:
		if GetInputDir() < 0 and velocity.x < 0:
			animatedSprite.flip_h = true
		elif GetInputDir() > 0 and velocity.x > 0:
			animatedSprite.flip_h = false
			
#Cheat button
func Cheat() -> void:
	if Input.is_action_pressed("fly"):
		velocity.y = -200
		Walk()
