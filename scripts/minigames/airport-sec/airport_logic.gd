extends Node

@onready var character_1:	OptionButton = $Character1
@onready var checker:		OptionButton = $Checker
@onready var character_2:	OptionButton = $Character2

var path_to_data = "res://assets/resources/airport.json"
var file = FileAccess.open(path_to_data, FileAccess.READ)
var data = JSON.parse_string(file.get_as_text())

var option:Array		= ["male", "female", "neutral"]

func _ready() -> void:
	var npc_list:Array		= random_npc_data()
	var anomalys_list:Array	= anomaly(npc_list)
	for npc in npc_list:
		var text = "name: %s\n surname: %s\nid: %s" % [npc["name"], npc["surname"], npc["id"]]
		character_1.add_item(text)	


func random_npc_data() -> Array[Dictionary]:
	var npc:Array[Dictionary]
	
	for i in range(10):
		var person:Dictionary 
		var category:String 			= option.pick_random()
		var list:Array[Dictionary]  	= data["names"][category]
		person["name"]  	= list.pick_random()

		list 				= data["surnames"]
		person["surname"]	= list.pick_random()
		person["id"]		= randi_range(10000000, 99999999)
		person["debugId"]	= i

		npc.append(person)
	
	return npc

func anomaly(original:Array[Dictionary]) -> Array[Dictionary]:
	var anomaly_list:Array[Dictionary]	= []
	var size:int		= original.size()
	var percent:int		= floor(randf_range(0.1, 0.4) * size)
	
	for anomaly_char in range(percent):
		var character:Dictionary = original.pick_random().duplicate(true)
		var options:Array[String] = ["names", "surnames", "id"]
		
		for anomalies in randi_range(1, 4):
			var selector:String = options.pick_random()
			
			if selector == "names":
				var mutation:Array[Dictionary] = data["names"]["neutral"]
				character["name"] = mutation.pick_random()
			elif selector == "surnames":
				var mutation:Array[Dictionary] = data["surnames"]
				character["surname"] = mutation.pick_random()
			else:
				character["id"] = randi_range(10000000, 99999999)
				
		anomaly_list.append(character)
	
	return	anomaly_list

func check():
	pass
	
