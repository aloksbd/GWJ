extends KinematicBody2D

const UP = Vector2(0,-1)
const SPEED = 100
const ACCELERATION = 25
var GRAVITY = 10
var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	
	motion =  move_and_slide(motion,UP)


func shootTo(left):
	if left:
		motion.x = -SPEED
	else:
		motion.x = SPEED


func _on_eatingArea_body_entered(body):
	if "red" in body.name:
		body.eatSugar()
		eater = body
		$AnimationPlayer.play("ate")
		GRAVITY = 0
		motion.y = 0

var eater = null
func _on_sugarSensor_body_entered(body):
	if "red" in body.name:
		body.moveToSugar(position)
		
func finish():
	queue_free()
	eater.finishEating()
	
