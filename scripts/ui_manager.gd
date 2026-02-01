extends Node

var game_over_screen: CanvasLayer = null

func show_game_over() -> void:
	print("UIManager.show_game_over() called. game_over_screen =", game_over_screen)

	if game_over_screen == null:
		push_error("UIManager.game_over_screen is null (not assigned).")
		return

	game_over_screen.show_game_over()
