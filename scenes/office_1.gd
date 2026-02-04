extends Node2D

@onready var gos := $GameOverScreen
@onready var player_camera: Camera2D = $player/Camera2D

func _ready() -> void:
	print("World ready. Assigning UIManager.game_over_screen =", gos)
	UIManager.game_over_screen = gos
	player_camera.limit_left   = 0
	player_camera.limit_top    = 0
	player_camera.limit_right  = 500
	player_camera.limit_bottom = 300


func _process(_delta: float) -> void:
	pass
