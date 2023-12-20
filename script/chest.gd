extends StaticBody2D

var player = null

var is_closed = false
var is_empty = false

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("harvest") and player != null:
		change_state()


func change_state():
	is_closed = !is_closed
	if is_closed:
		$AnimatedSprite2D.play("closed")
	else:
		$AnimatedSprite2D.play("open")


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		print("Player entered")
		player = body


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		player = null
		print("Player left")
