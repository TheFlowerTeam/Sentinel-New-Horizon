# Kod wspomagany AI
extends Node


#region NPC
@onready var texture_npc: Sprite2D = %TextureNPC
@onready var sound_npc: AudioStreamPlayer2D = %SoundNPC
#endregion

#region Document
@onready var personal_document: Label = %PersonalDocument
@onready var bday_document: Label = %BdayDocument
@onready var id_document: Label = %IdDocument
#endregion

#region Pasport
@onready var name_pasport: Label = %NamePasport
@onready var surname_pasport: Label = %SurnamePasport
@onready var id_pasport: Label = %IdPasport
#endregion

#region AdditionalFunctions
func display_current_npc() -> void:
	var npc: NPC = npc_list[current_npc_index]
	personal_document.text = "Imię i nzawisko: %s %s" % [npc.npc_name, npc.npc_surname]
	bday_document.text = "Urodzony/a: %s" % npc.npc_birthday
	id_document.text = "Numer ID: %s" % npc.npc_id
	var path_to_img:String = npc.npc_img
	texture_npc.texture = load(path_to_img)
	
func generate_npc_list(count: int) -> Array:
	var list: Array = []
	for i in range(count):
		var npc = NPC.new()
		npc.generate_npc()
		npc.npc_debug = i
		list.append(npc)
	return list

#endregion


var npc_list: Array = []
var current_npc_index: int = 0

func _ready() -> void:
	#load_game_data()
	npc_list = generate_npc_list(10)
	display_current_npc()

func _on_button_pressed() -> void:
	current_npc_index = (current_npc_index + 1) % npc_list.size()
	display_current_npc()
