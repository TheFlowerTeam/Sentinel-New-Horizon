extends Node

@export_category("Ustawienia wstępne")
@export_group("Clock")
@export_range(0, 23, 1, "prefer_slider") var start_hour: int = 10
@export_range(0, 23, 1, "prefer_slider") var end_hour: int = 20
@export_range(0, 60, 5, "prefer_slider") var step: int = 15
@export var clock_wait_time: float = 15.0 

@export_group("")
@export var notify_tscn: PackedScene
@export var notify_container: Control

@onready var day: Label = %Day
@onready var clock: Label = %Clock
@onready var timer: Timer = %Timer
@onready var daily: Panel = %Daily
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var settings_menu: Popup = %SettingsMenu
@onready var upgrades_menu: Popup = %UpgradesMenu
@onready var achivements_menu: Popup = %AchivementsMenu


var current_hour: int = start_hour * 60 # Minuty startowe
var animation_timer: float = 0.0
var animation_played: bool = false

# Notification Sound Effect by SoundShelfStudio from Pixabay

func _ready() -> void:
	timer.wait_time = clock_wait_time
	end_hour *= 60 # Przeliczamy godzine koncowa na minuty
	update_time()

func _on_timer_timeout() -> void:
	update_time()

func _process(delta: float) -> void:
	if current_hour >= end_hour - 60:
		animation_timer += delta
		
		if int(animation_timer * 2) % 2 == 0:
			clock.modulate = Color.CRIMSON
		else:
			clock.modulate = Color.WHITE
	
func update_time() -> void:
	var minutes: int = current_hour % 60 # Obliczamy minuty 
	
	@warning_ignore("integer_division")
	var hour: int = floor(current_hour / 60) # Przeliczamy minuty na godziny
	
	clock.text = "%02d : %02d" % [hour, minutes]
	
	if current_hour >= end_hour and !animation_played:
		animation_played = true
		animation_player.play("PanelShowUp")
		get_tree().paused = true

	current_hour += step #  Zwiekszamy licznik o krok
	

func _on_upgrades_button_button_down() -> void:
	upgrades_menu.open_popup(false)


func _on_continue_button_button_down() -> void:
	notify("Zapisano grę !")
	
func notify(message:String) -> void:
	var popup = notify_tscn.instantiate()
	popup.setup(message)
	notify_container.add_child(popup)
	
