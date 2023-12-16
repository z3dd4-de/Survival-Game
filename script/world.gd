extends Node2D

@onready var tutorial_message_1_shown = false
func _ready():
	#PlayerStats.send_message("Arm yourself with the bow (1)!")
	pass


func _process(_delta):
	if !tutorial_message_1_shown:
		PlayerStats.send_message("Arm yourself with the bow (1)!")
		tutorial_message_1_shown = true


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("help"):
		$CanvasLayer/KeyboardLayoutPanel.visible = !$CanvasLayer/KeyboardLayoutPanel.visible



