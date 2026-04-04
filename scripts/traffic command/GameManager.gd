extends Node2D

#Left
@onready var k1_followers = [$Left/Path2D_1/PathFollow2D, $Left/Path2D_2/PathFollow2D, $Left/Path2D_3/PathFollow2D]
@onready var k1_paths = [$Left/Path2D_1, $Left/Path2D_2, $Left/Path2D_3]
@onready var k1_vehicle = $Left/Path2D_1/PathFollow2D/Node2D

#Down
@onready var k2_followers = [$Down/Path2D_1/PathFollow2D, $Down/Path2D_2/PathFollow2D, $Down/Path2D_3/PathFollow2D]
@onready var k2_paths = [$Down/Path2D_1, $Down/Path2D_2, $Down/Path2D_3]
@onready var k2_vehicle = $Down/Path2D_1/PathFollow2D/Node2D

#Right
@onready var k3_followers = [$Right/Path2D_1/PathFollow2D, $Right/Path2D_2/PathFollow2D, $Right/Path2D_3/PathFollow2D]
@onready var k3_paths = [$Right/Path2D_1, $Right/Path2D_2, $Right/Path2D_3]
@onready var k3_vehicle = $Right/Path2D_1/PathFollow2D/Node2D

#Up
@onready var k4_followers = [$Up/Path2D_1/PathFollow2D, $Up/Path2D_2/PathFollow2D, $Up/Path2D_3/PathFollow2D]
@onready var k4_paths = [$Up/Path2D_1, $Up/Path2D_2, $Up/Path2D_3]
@onready var k4_vehicle = $Up/Path2D_1/PathFollow2D/Node2D

@onready var ui = $Menu

var directions: Array = []

func _ready() -> void:
	directions = [
		{ "followers": k1_followers, "paths": k1_paths, "vehicle": k1_vehicle, "active_index": -1, "active_follower": null },
		{ "followers": k2_followers, "paths": k2_paths, "vehicle": k2_vehicle, "active_index": -1, "active_follower": null },
		{ "followers": k3_followers, "paths": k3_paths, "vehicle": k3_vehicle, "active_index": -1, "active_follower": null },
		{ "followers": k4_followers, "paths": k4_paths, "vehicle": k4_vehicle, "active_index": -1, "active_follower": null },
	]
	
	for d in directions:
		var area = d["vehicle"].get_node("Area2D")
		area.crashed.connect(_on_crash)
	
	for i in range(directions.size()):
		_pick_random(i)

func _pick_random(dir_index: int) -> void:
	var d = directions[dir_index]
	
	if d["active_index"] != -1:
		d["paths"][d["active_index"]].hide_path()
		
		var old_follower = d["active_follower"]
		if old_follower.reached_stop.is_connected(func(): _on_reached_stop(dir_index)):
			old_follower.reached_stop.disconnect(func(): _on_reached_stop(dir_index))
		if old_follower.route_finished.is_connected(func(): _pick_random(dir_index)):
			old_follower.route_finished.disconnect(func(): _pick_random(dir_index))
		
		var old_area = d["vehicle"].get_node("Area2D")
		if old_area.clicked.is_connected(func(): _on_vehicle_clicked(dir_index)):
			old_area.clicked.disconnect(func(): _on_vehicle_clicked(dir_index))
	
	var new_index = d["active_index"]
	while new_index == d["active_index"]:
		new_index = randi() % 3
	
	d["active_index"] = new_index
	d["active_follower"] = d["followers"][d["active_index"]]
	
	var vehicle = d["vehicle"]
	vehicle.reparent(d["active_follower"], false)
	vehicle.position = Vector2.ZERO
	
	d["paths"][d["active_index"]].show_path()
	d["active_follower"].reset()
	d["active_follower"].reached_stop.connect(func(): _on_reached_stop(dir_index))
	d["active_follower"].route_finished.connect(func(): _on_route_finished(dir_index))
	
	print("Kierunek ", dir_index + 1, " — wylosowano trasę: ", new_index + 1)

func _on_reached_stop(dir_index: int) -> void:
	var d = directions[dir_index]
	var area = d["vehicle"].get_node("Area2D")
	area.enable_click()
	if not area.clicked.is_connected(func(): _on_vehicle_clicked(dir_index)):
		area.clicked.connect(func(): _on_vehicle_clicked(dir_index))

func _on_vehicle_clicked(dir_index: int) -> void:
	directions[dir_index]["active_follower"].continue_moving()

func _on_route_finished(dir_index: int) -> void:
	ui.add_finished_vehicle()
	_pick_random(dir_index)

func _on_crash() -> void:
	print("Kolizja — koniec gry!")
	get_tree().paused = true
