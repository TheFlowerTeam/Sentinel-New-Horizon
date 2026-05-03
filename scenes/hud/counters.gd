extends VBoxContainer

@export_category("Ustawienia wstępne")
@export_group("Clock")
@export_range(0, 23, 1, "prefer_slider") var start_hour: int = 10
@export_range(0, 23, 1, "prefer_slider") var end_hour: int = 20
@export_range(0, 60, 5, "prefer_slider") var step: int = 15
@export var clock_wait_time: float = 15.0 


@onready var day: Label = $Day
@onready var clock: Label = %Clock
@onready var timer: Timer = %Timer

var current_hour: int = start_hour * 60 # Minuty startowe
var animation_timer: float = 0.0

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
	current_hour += step #  Zwiekszamy licznik o krok
	
	if current_hour >= end_hour:
		pass
