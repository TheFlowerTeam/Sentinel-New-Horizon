extends Node

const SAVE_LOCATION = "user://SaveFile.dat"
const PASS = "8fgds97ghy"

const DEFAULT_SAVE: Dictionary = {
	"volume_master": 0.75,
	"volume_music": 0.75,
	"volume_sfx": 0.75,
	"game_day": 0
	#tutaj wpisuje dane które ma zapisywać
}

var contents_to_save: Dictionary = DEFAULT_SAVE.duplicate()

func _ready() -> void:
	load_content()

func _reset():
	contents_to_save = DEFAULT_SAVE.duplicate()

func save_content():
	var file = FileAccess.open_encrypted_with_pass(SAVE_LOCATION, FileAccess.WRITE, PASS)
	if file == null:
		push_error("Nie można otworzyć pliku do zapisu: %s" % FileAccess.get_open_error())
		return
	file.store_var(contents_to_save.duplicate())
	file.close()

func load_content():
	if not FileAccess.file_exists(SAVE_LOCATION):
		return
	
	var file = FileAccess.open_encrypted_with_pass(SAVE_LOCATION, FileAccess.READ, PASS)
	if file == null:
		push_error("Nie można otworzyć pliku do odczytu: %s" % FileAccess.get_open_error())
		return
	
	var data = file.get_var()
	file.close()
	
	if not data is Dictionary:
		push_error("Uszkodzone dane zapisu!")
		return
	
	for key in contents_to_save:
		if data.has(key):
			contents_to_save[key] = data[key]
