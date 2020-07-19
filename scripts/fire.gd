extends Area2D

var speed = 170
const TIMER = 2.5
var velocity = Vector2()
var left = false

func _ready():
	$AnimationPlayer.play("shoot")
	yield(get_tree().create_timer(TIMER), "timeout")
	queue_free()

func shootTo(_left):
	left = _left
	if left:
		$Sprite.flip_h = true
		speed = -speed
	
func _physics_process(delta):
	if !left:
		velocity.x = speed * delta
	else:
		velocity.x = speed * delta
	translate(velocity)

func _on_fire_body_entered(body):
	if "neo" in body.name:
		#body.hit()
		queue_free()
