extends "res://scripts/effect.gd"


func _ready() -> void:
	super()
	Sound.play(Sound.explosion)
