extends KinematicBody2D

const UP = Vector2(0,-1)
const SPEED = 80
const ACCELERATION = 25
const GRAVITY = 10
var motion = Vector2()
var canShoot = true
var moveRight = false
var eating = false
var antDetected = false
var sugarDetected = false

onready var fire_scene = preload("res://scenes/fire.tscn")

func _ready():
	changeDirection()

func _physics_process(delta):
	motion.y += GRAVITY
	if eating: 
		motion.y = 0
	if antDetected && !sugarDetected:
		motion.x = 0
		$AnimationPlayer.play("idle")
	elif eating: 
		$AnimationPlayer.play("eat")
		motion.x = 0
	elif moveRight:
		$AnimationPlayer.play("walk")
		$Sprite.flip_h = true
		motion.x = min(motion.x + ACCELERATION, SPEED)
	else:
		$AnimationPlayer.play("walk")
		$Sprite.flip_h = false
		motion.x = max(motion.x - ACCELERATION, -SPEED)

	motion =  move_and_slide(motion,UP)
	
func changeDirection():
	yield(get_tree().create_timer(3), "timeout")
	if !sugarDetected:
		moveRight = !moveRight
		changeDirection()

func shoot():
	print(canShoot,antDetected,sugarDetected)
	if canShoot:
		var fire = fire_scene.instance()
		fire.position = global_position
		fire.shootTo(!$Sprite.flip_h)
		get_parent().add_child(fire)
		canShoot = false
		
	yield(get_tree().create_timer(1.5), "timeout")
	if !sugarDetected:
		canShoot = true
		
	if antDetected:
			shoot()
		

func _on_sensor_body_entered(body):
	if "purple" in body.name:
		antDetected = true
		if !sugarDetected:
			shoot()

func _on_sensor_body_exited(body):
	if "purple" in body.name:
		antDetected = false

func moveToSugar(pos):
	sugarDetected = true
	if position.x > pos.x:
		moveRight = false
	else:
		moveRight = true
		
func eatSugar():
	$AnimationPlayer.play("eat")
	eating = true
	$CollisionShape2D.set_deferred("disabled", true)
	
func finishEating():
	eating = false
	sugarDetected = false
	changeDirection()
	$CollisionShape2D.set_deferred("disabled", false)
