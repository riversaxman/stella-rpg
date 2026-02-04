extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true


func show_start_screen() -> void:
	visible = true
	get_tree().paused = true
	$Control/CenterContainer/ColorRect/CenterContainer2/VBoxContainer/StartButton.grab_focus()

	
func _on_start_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://scenes/IntroDialogue.tscn")
