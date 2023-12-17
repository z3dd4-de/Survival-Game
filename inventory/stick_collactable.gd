class_name Stick extends StaticBody2D

@export var item: InvItem
var player = null

@onready var tutorial_message_4_shown = false

func _on_interactable_area_body_entered(body):
	if body.has_method("player"):
		player = body
		if !tutorial_message_4_shown:
			PlayerStats.send_message("Press \"E\" to collect the stick")
			tutorial_message_4_shown = true


func _process(_delta):
	playercollect()


func playercollect():
	if Input.is_action_just_pressed("harvest") and player != null:
		player.collect(item)
		await get_tree().create_timer(0.3).timeout
		self.queue_free()


func _on_interactable_area_body_exited(body):
	player = null
