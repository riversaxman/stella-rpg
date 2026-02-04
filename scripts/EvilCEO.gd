extends "res://scripts/BaseEnemy.gd"

func die() -> void:
	self.queue_free()
	UIManager.show_win()
