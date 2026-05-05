extends Node2D

@export_category("Alerts")
@export var popup_scene: PackedScene


@onready var map: Sprite2D = %Map

func _ready() -> void:
	var map_size: Vector2 = map.texture.get_size()
	var popup = popup_scene.instantiate()
	popup.position.x = randf_range(0, map_size.x)
	popup.position.y = randf_range(0, map_size.y)
	map.add_child(popup)
