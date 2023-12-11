class_name Campfire extends StaticBody2D
#https://opengameart.org/content/outdoor-tileset

var is_burning = false
var is_placed = false

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inflame()



func inflame():
	if Input.is_action_just_pressed("fire") and player != null:
		is_burning = !is_burning
	if is_burning:
		$AnimatedSprite2D.play("burning")
	else:
		$AnimatedSprite2D.play("not_burning")



func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player = body


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		player = null
