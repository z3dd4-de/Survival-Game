class_name Player extends CharacterBody2D

const SPEED = 100

signal healthChanged
signal hungerChanged
signal thirstChanged
signal playerDied


var player_state
@onready var is_hurt = false
@onready var is_alive = true

@export var inv: Inventory

var bow_equiped = false
var bow_cooldown = true
var arrow = preload("res://scene/arrow.tscn")
var mouse_loc_from_player = null

@onready var max_health = 100
@onready var current_health = max_health
@onready var max_hunger = 100
@onready var current_hunger = max_hunger
@onready var max_thirst = 100
@onready var current_thirst = max_thirst
@onready var hurtBox = $hurtBox
@onready var hurtTimer = $hurtBox/hurtTimer
@onready var inventory = preload("res://inventory/inventory_ui.tscn")
@onready var inventory_stacked = $InventoryStacked
@onready var ctrl_inventory_stacked = $CtrlInventoryStacked
# Audio
@onready var arrow_audio = $ArrowAudio
@onready var player_dying = $PlayerDying
@onready var pick_item = $PickItem

#var inv_instance:InventoryUi

@onready var camera = $Camera2D


func _physics_process(_delta):
	if is_alive:
		handleInput()
		move_and_slide()
	
		if !is_hurt:
			for area in hurtBox.get_overlapping_areas():
				if area.name == "hitbox":
					hurtByEnemy(area)


func _ready():
	#inv_instance = InventoryUi.new()
	pass


func play_anim(dir):
	if !bow_equiped:
		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
		if player_state == "walking":
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			elif dir.y == 1:
				$AnimatedSprite2D.play("s-walk")
			if dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
			elif  dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
			
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne-walk")
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-walk")
	else:	#bow_equiped = true
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
			$AnimatedSprite2D.play("n-attack")
		elif mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			$AnimatedSprite2D.play("e-attack")
		elif mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			$AnimatedSprite2D.play("s-attack")
		elif mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			$AnimatedSprite2D.play("w-attack")
		
		elif mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("ne-attack")
		elif mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("se-attack")
		elif mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("sw-attack")
		elif mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("nw-attack")

func handleInput():
	mouse_loc_from_player = get_global_mouse_position() - self.position
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif  direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
	velocity = direction * SPEED
	
	if Input.is_action_just_pressed("bow"):
		bow_equiped = !bow_equiped
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("left_mouse") and bow_equiped and bow_cooldown:
		arrow_audio.play()
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position + Vector2(randi_range(0,15-PlayerStats.shooting),randi_range(0,15-PlayerStats.shooting))
		add_child(arrow_instance)
		await get_tree().create_timer(0.4).timeout
		bow_cooldown = true
		
	if Input.is_action_just_pressed("drink"):
		drink()
		#drinkWater.emit()
		pass
		
	if Input.is_action_just_pressed("eat"):
		#eatApple.emit()
		eat()
		pass
	
	play_anim(direction)

func player():
	pass

func hurtByEnemy(area):
	current_health -= 10
	checkHealth()
	is_hurt = true
	PlayerStats.player_hit = true
	healthChanged.emit()
	#showHit()
	hurtTimer.start(1.0)
	await hurtTimer.timeout
	is_hurt = false
	PlayerStats.player_hit = false


func checkHealth():
	if current_health < 30:
		PlayerStats.player_hit = true
	if current_health <= 0:
		player_dying.play()
		current_health = 0
		is_alive = false
		$AnimatedSprite2D.play("death")
		hurtTimer.start(2)
		await hurtTimer.timeout
		playerDied.emit()
		

func showHit():
	#$AnimatedSprite2D.frame.setColor...
	pass


func collect(item):
	#inv.insert(item)
	pick_item.play()


func hungry():
	current_hunger -= 10
	hungerChanged.emit()
	if current_hunger <= 0:
		current_hunger = 0
		current_health -= 10
		checkHealth()
		healthChanged.emit()


func thirsty():
	current_thirst -= 10
	thirstChanged.emit()
	if current_thirst <= 0:
		current_thirst = 0
		current_health -= 10
		checkHealth()
		healthChanged.emit()


func _on_hunger_timer_timeout():
	hungry()
	$hungerTimer.start()


func _on_thirst_timer_timeout():
	thirsty()
	$thirstTimer.start()


func drink():
	#inventory.remove_water()
	#inv_instance.remove_water()
	pass


func eat():
	pass
