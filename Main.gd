extends Node2D

@onready var shake_a_camera: CameraShaker = $Camera2D/ShakeACamera

func _on_button_pressed() -> void:
	shake_a_camera.shake(1.0,20.0,20.0)
