extends CharacterBody2D

@export var speed: float = 25.0
@export var max_health = 100
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var agent: NavigationAgent2D = $NavigationAgent2D

var chase_player = false
var player = null
var current_direction = "front"

var health = 100
var player_inattack_range = false
var can_take_damage = true

func _ready() -> void:
	agent.path_desired_distance = 4.0
	agent.target_desired_distance = 8.0

func _physics_process(delta: float) -> void:
	deal_damage()
	update_health()

	if chase_player and is_instance_valid(player):
		agent.target_position = player.global_position

		var next_position: Vector2 = agent.get_next_path_position()
		var direction: Vector2 = (next_position - global_position)
		
		if direction.length() > 2.0:
			direction = direction.normalized()
			velocity = direction * speed
			_update_direction(direction)
			_play_move_animation()
		else:
			velocity = Vector2.ZERO
			_play_idle_animation()
	else:
		velocity = Vector2.ZERO
		_play_idle_animation()

	move_and_slide()


func _update_direction(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		current_direction = "right" if direction.x > 0.0 else "left"
	else:
		current_direction = "front" if direction.y > 0.0 else "back"

		
func _play_move_animation() -> void:
	var animation_name: String = current_direction + "_walk"
	
	if not animation.sprite_frames.has_animation(animation_name):
		animation_name = current_direction + "_idle"
	if animation.animation != animation_name:
		animation.play(animation_name)
		

func _play_idle_animation() -> void:
	var animation_name: String = current_direction + "_idle"
	
	if animation.animation != animation_name:
		animation.play(animation_name)	

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	chase_player = true
	print("entered", body)

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	chase_player = false

func enemy():
	pass

func _on_policeman_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_range = true

func _on_policeman_hitbox_body_exited(body: Node2D) -> void:
	if body.has_meta("player"):
		player_inattack_range = false

func deal_damage():
	if player_inattack_range and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("Policeman health: ", health)
			if health <= 0:
				self.queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	
func update_health():
	var health_bar = $health_bar
	health_bar.value = health
	
	if health >= max_health:
		health_bar.visible = false
	else:
		health_bar.visible = true
