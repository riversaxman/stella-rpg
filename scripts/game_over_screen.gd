extends CanvasLayer

@onready var game_over_label: Label = $Control/CenterContainer/VBoxContainer/game_over

func _ready() -> void:
	visible = false

func show_game_over():
	game_over_label.text = "Game Over"
	visible = true
	get_tree().paused = true
	$Control/CenterContainer/VBoxContainer/RetryButton.grab_focus()
	
func show_win():
	game_over_label.text = "You Win!"
	visible = true
	get_tree().paused = true
	$Control/CenterContainer/VBoxContainer/RetryButton.grab_focus()

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/office1.tscn") 
