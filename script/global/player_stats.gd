extends Node

var experience
var shooting
var hits
var day
var start_time
var end_time
var player_hit = false

signal ShootingChanged
signal DayChanged
signal DrinkWater
signal EatApple
signal sendMessage
signal StickCollected


func _ready():
	experience = 0
	shooting = 1
	hits = 0
	day = 1
	start_time = Time.get_unix_time_from_system()


func changeDay():
	day += 1
	DayChanged.emit()


func shooting_level(hit = 1):
	hits += hit
	var tmp = shooting
	if hits < 10:
		shooting = 1
	elif hits >= 10 and hits < 25:
		shooting = 2
	elif hits >= 25 and hits < 100:
		shooting = 3
	elif hits >= 100 and hits < 250:
		shooting = 4
	elif hits >= 250 and hits < 500:
		shooting = 5
	elif hits >= 500 and hits < 1000:
		shooting = 6
	elif hits >= 1000 and hits < 2500:
		shooting = 7
	elif hits >= 2500 and hits < 5000:
		shooting = 8
	elif hits >= 5000 and hits < 10000:
		shooting = 9
	else:
		shooting = 10  
	
	if shooting > tmp:
		ShootingChanged.emit()


func send_message(text: String):
	sendMessage.emit(text)
