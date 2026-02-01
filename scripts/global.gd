extends Node

var player_current_attack = false

var current_scene = "world"
var transition

func _on_enemy_dies(heal_amount: int) -> void:
	$player.heal(heal_amount)
