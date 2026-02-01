extends Node2D

@onready var gos := $GameOverScreen

func _ready() -> void:
	print("World ready. Assigning UIManager.game_over_screen =", gos)
	UIManager.game_over_screen = gos


func _process(delta: float) -> void:
	pass
