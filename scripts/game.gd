extends Node2D

func _ready() -> void:
	GameEvents.menu_switched.connect(_on_menu_switched)
	
func _on_menu_switched(is_open:bool) -> void:
	get_tree().paused = is_open
	pass
	
