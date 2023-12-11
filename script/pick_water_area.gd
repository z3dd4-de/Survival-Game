extends Area2D

@export var player: Player
@export var item: InvItem

func _process(delta):
	pick_water()


func pick_water():
	if Input.is_action_just_pressed("harvest") and player != null:
		player.collect(item)


func _on_body_entered(body):
	if body.has_method("player"):
		player = body


func _on_body_exited(body):
	if body.has_method("player"):
		player = null
