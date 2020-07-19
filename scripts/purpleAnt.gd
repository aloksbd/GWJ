extends KinematicBody2D

const UP = Vector2(0,-1)
const SPEED = 100
const ACCELERATION = 25
const GRAVITY = 10
var motion = Vector2()
var canShoot = true

onready var sugar_scene = preload("res://scenes/sugar.tscn")

func _physics_process(delta):
	motion.y += GRAVITY
	if Input.is_action_pressed("ui_right"):
		$AnimationPlayer.play("walk")
		$Sprite.flip_h = false
		$sugarSpawner.position.x = 48
		motion.x = min(motion.x + ACCELERATION, SPEED)
	elif Input.is_action_pressed("ui_left"):
		$AnimationPlayer.play("walk")
		$Sprite.flip_h = true
		$sugarSpawner.position.x = -48
		motion.x = max(motion.x - ACCELERATION, -SPEED)
	else:
		$AnimationPlayer.play("idle")
		motion.x = 0
	motion =  move_and_slide(motion,UP)
	
func _process(delta):
	if canShoot && Input.is_action_just_pressed("ui_throwSugar"):
		
		var sugar = sugar_scene.instance()
		sugar.position = $sugarSpawner.global_position
		sugar.shootTo($Sprite.flip_h)
		get_parent().add_child(sugar)
		canShoot = false
		yield(get_tree().create_timer(0.3), "timeout")
		canShoot = true

	if canShoot && Input.is_action_just_pressed("ui_placeAndStandOverSugar"):
		
		var sugar = sugar_scene.instance()
		sugar.position = global_position
		self.position.x = sugar.global_position.x
		position.y = sugar.global_position.y-48
		#sugar.shootTo($Sprite.flip_h)
		get_parent().add_child(sugar)
		canShoot = false
		yield(get_tree().create_timer(0.3), "timeout")
		canShoot = true
