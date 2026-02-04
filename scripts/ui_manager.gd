extends Node

var game_over_screen: CanvasLayer = null
var start_screen: CanvasLayer = null
var intro_screen: CanvasLayer = null

func show_start_screen() -> void:
	if start_screen == null:
		return

	start_screen.show_start_screen()


func show_intro_screen() -> void:
	if intro_screen == null:
		return

	intro_screen.show_intro_screen()
	

func show_game_over() -> void:
	if game_over_screen == null:
		push_error("UIManager.game_over_screen is null (not assigned).")
		return

	game_over_screen.show_game_over()

	
func show_win() -> void:
	if game_over_screen == null:
		push_error("UIManager.game_over_screen is null (not assigned).")
		return

	game_over_screen.show_win()
