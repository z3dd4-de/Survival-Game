extends StaticBody2D

enum state { DAY, NIGHT }
var current_state = state.DAY
var change_state = false

var length_of_day = 120
var length_of_night = 60

func _ready():
	if current_state == state.DAY:
		$ColorRect.color.a = 0
	else:
		$ColorRect.color.a = 225


func _on_timer_timeout():
	match current_state:
		state.DAY:
			current_state = state.NIGHT
		state.NIGHT:
			current_state = state.DAY
	change_state = true
	
func _process(delta):
	if change_state:
		change_state = false
		if current_state == state.DAY:
			change_to_day()
		else:
			change_to_night()


func change_to_day():
	$AnimationPlayer.play("night_to_day")
	$Timer.wait_time = length_of_day
	$Timer.start()
	PlayerStats.changeDay()


func change_to_night():
	$AnimationPlayer.play("day_to_night")
	$Timer.wait_time = length_of_night
	$Timer.start()
