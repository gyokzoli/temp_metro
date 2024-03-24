extends Area2D

var is_active: bool = true

signal trigger_entered


func _on_body_entered(_body: Node2D) -> void:
	if not is_active: return
	trigger_entered.emit()
