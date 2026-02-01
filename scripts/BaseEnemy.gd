extends CharacterBody2D
class_name BaseEnemy

# exporting these so we can edit in GUI
@export var speed: float = 25.0  # movement speed
@export var max_health: int = 100
@export var path_desired_distance: float = 4.0
@export var target_desired_distance: float = 8.0
@export var heal_on_death: int = 20

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var agent: NavigationAgent2D = $NavigationAgent2D

var chase_player: bool = false
# player object that enemy is currently interacting with
var player = null  
# direction of character animation
var current_direction: String = "front"
var health: int
var player_in_attack_range: bool = false
# whether player can currently attack (or if cooldown timer is active)
var can_take_damage: bool = true


func _ready() -> void:
	health = max_health
	agent.path_desired_distance = path_desired_distance
	agent.target_desired_distance = target_desired_distance


func _physics_process(delta: float) -> void:
	deal_damage()
	update_health()
	
	if chase_player and is_instance_valid(player):
		# enemy should try to approach player, avoiding obstacles
		agent.target_position = player.global_position

		var next_position: Vector2 = agent.get_next_path_position()
		var direction: Vector2 = (next_position - global_position)
		
		# continue to chase the player
		if direction.length() > 2.0:
			direction = direction.normalized()
			velocity = direction * speed
			_update_direction(direction)
			_play_move_animation()
		else:
			# can stop chasing, player is in range
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
	
	if not animated_sprite.sprite_frames.has_animation(animation_name):
		animation_name = current_direction + "_idle"
		
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)


func _play_idle_animation() -> void:
	var animation_name: String = current_direction + "_idle"
	
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)


func _on_detection_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player = body
	chase_player = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body != player:
		return
	player = null
	chase_player = false


func enemy():
	pass


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	#todo not sure if this is right, should it be has_meta?
	if body.is_in_group("player"):
		player_in_attack_range = false


func deal_damage() -> void:
	if player_in_attack_range and global.player_current_attack == true:
		if can_take_damage == true:
			# todo -- damage amount should come from player, how?
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("enemy_health: ", health)
			if health <= 0:
				die()

func die() -> void:
	if is_instance_valid(player) and player.has_method("heal"):
		player.heal(heal_on_death)
	self.queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true


func update_health() -> void:
	#todo simplify this
	var health_bar = $health_bar
	health_bar.value = health
	
	if health == max_health:
		health_bar.visible = false
	else:
		health_bar.visible = true
	
