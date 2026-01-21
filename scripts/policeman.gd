extends CharacterBody2D

@export var speed = 50
var chase_player = false
var player = null

func _physics_process(delta: float) -> void:
	if chase_player:
		position += (player.position - position) / speed


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	chase_player = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	chase_player = false
