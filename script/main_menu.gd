extends TextureRect

@onready var menu_music = $MenuMusic






func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://scene/world.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
