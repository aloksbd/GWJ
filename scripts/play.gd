extends Area2D




func _on_play_body_entered(body):
	if "purple" in body.name:
		get_tree().change_scene("res://scenes/MainLevel.tscn")
