extends Node2D

@onready var player_camera: Camera2D = $player/Camera2D

func _ready() -> void:
	player_camera.limit_left   = 0
	player_camera.limit_top    = 0
	player_camera.limit_right  = 1000
	player_camera.limit_bottom = 500


func _process(_delta: float) -> void:
	pass
