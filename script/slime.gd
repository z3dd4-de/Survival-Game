class_name Slime extends CharacterBody2D

const SPEED = 50.0

var max_health = 100
var current_health = max_health

var is_dead = false
var player = null

@onready var slime = $slime_collectable
@export var itemRes = InvItem
@onready var healthBar = $healthBar
@onready var hit_sound = $HitSound
@onready var dead_sound = $DeadSound
@onready var inv_pick = $InventoryPick

func _ready():
	healthBar.value = current_health
	$slime_collectable/collect_area.visible = false


func _process(_delta):
	playercollect()


func _physics_process(delta):
	if !is_dead:
		$detection_area/CollisionShape2D.disabled = false
		if player != null:
			position += (player.position - position) / SPEED
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
	else:	# is_dead
		$detection_area/CollisionShape2D.disabled = true

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body


func _on_detection_area_body_exited(body):
	#if body.has_method("player"):
	#	player = null
	pass


func _on_hitbox_area_entered(area):
	var damage
	if area.has_method("arrow_deal_damage"):
		damage = 100 * PlayerStats.shooting / 10
		take_damage(damage)


func take_damage(damage: int):
	hit_sound.play()
	PlayerStats.shooting_level()
	current_health -= damage
	healthBar.value = current_health
	if current_health <= 0 and !is_dead:
		death()


func death():
	dead_sound.play()
	PlayerStats.shooting_level(5) #Bonus for kill
	is_dead = true
	var temp_player = player
	$AnimatedSprite2D.play("death")
	healthBar.visible = false
	await get_tree().create_timer(1).timeout
	
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	if temp_player != null:
		player = temp_player
	drop_slime()


func drop_slime():
	slime.visible = true
	$slime_collectable/collect_area.visible = true


func playercollect():
	if Input.is_action_just_pressed("harvest") and player != null and $slime_collectable/collect_area.visible:
		#player.collect(itemRes)
		#inv_pick.play()
		PlayerStats.SlimeCollected.emit()
		await get_tree().create_timer(0.3).timeout
		self.queue_free()


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player = body


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		print("Player: null")
		player = null


func enemy():
	pass
