extends LineEdit

@export var childrens_parent:Node


func _on_text_changed(new_text: String) -> void:
	new_text.to_lower()
	
	if new_text == "":
		for child in childrens_parent.get_children():
			var label = child.get_node("MarginContainer/HBoxContainer/Label")
			child.visible = true
	
	else:
		for child in childrens_parent.get_children():
			var label = child.get_node("MarginContainer/HBoxContainer/Label")
			var option_text = label.text.to_lower()
			
			child.visible = option_text.contains(new_text)
