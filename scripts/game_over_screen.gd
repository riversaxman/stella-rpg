extends CanvasLayer

func _ready() -> void:
	visible = false

func show_game_over():
	visible = true
	get_tree().paused = true
	$Control/CenterContainer/VBoxContainer/RetryButton.grab_focus()

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/office1.tscn") 


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/office1.tscn") 
