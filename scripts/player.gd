extends CharacterBody2D

@export var speed: float = 100.0
@export var max_health: int = 200
@export var damage: int = 20
@export var regen_heal: int = 20
var current_direction: String = "none"

var enemy_in_attack_range: bool = false
var enemy_attack_cooldown: bool = true
var health: int
var player_alive: bool = true

var attack_in_progress: bool = false

func _ready() -> void:
	UIManager.show_start_screen()
	$AnimatedSprite2D.play("front_idle")
	health = max_health
	update_health()
	$health_bar.max_value = max_health

func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()
	attack()
	update_health()
	
	if health <= 0:
		player_alive = false
		health = 0
		self.queue_free()
		UIManager.show_game_over()

	
func player_movement(_delta: float) -> void:
	if Input.is_action_pressed("right"):
		current_direction = "right"
		play_animation(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_direction = "left"
		play_animation(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_direction = "down"
		play_animation(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("up"):
		current_direction = "up"
		play_animation(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
	
func play_animation(movement) -> void:
	var direction: String = current_direction
	var animation: AnimatedSprite2D = $AnimatedSprite2D
	
	if direction == "right":
		if movement:
			animation.play("right_walk")
		else:
			if attack_in_progress == false:			 
				animation.play("right_idle")
	elif direction == "left":
		if movement:
			animation.play("left_walk")
		else:
			if attack_in_progress == false:			 
				animation.play("left_idle")
	elif direction == "down":
		if movement:
			animation.play("front_walk")
		else:
			if attack_in_progress == false:			 
				animation.play("front_idle")
	elif direction == "up":
		if movement:
			animation.play("back_walk")
		else:
			if attack_in_progress == false:			 
				animation.play("back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack() -> void:
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("player health: ", health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
func attack() -> void:
	var direction: String = current_direction
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_in_progress = true
		if direction == "right":
			$AnimatedSprite2D.play("right_attack")
		if direction == "left":
			$AnimatedSprite2D.play("left_attack")
		if direction == "up":
			$AnimatedSprite2D.play("back_attack")
		if direction == "down":
			$AnimatedSprite2D.play("front_attack")

		$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_in_progress = false

func update_health() -> void:
	$health_bar.value = health
	$health_bar.visible = (health < max_health)
	
func heal(heal_amount: int) -> void:
	health += heal_amount
	print("player heal on death: ", health)

func _on_regen_timer_timeout() -> void:
	if health < max_health and health > 0:
		health += regen_heal
		if health > max_health:
			health = max_health

	if health < 0:
		health = 0	
