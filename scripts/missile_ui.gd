extends HBoxContainer

@onready var label: Label = $Label


func _ready() -> void:
	if PlayerStats.max_missiles == 0:
		hide()
	update_missile_label()
	PlayerStats.missiles_changed.connect(update_missile_label)
	PlayerStats.max_missiles_changed.connect(_max_missiles_changed)
	
func update_missile_label() -> void:
	label.text = str(PlayerStats.missiles)

func _max_missiles_changed() -> void:
	visible = PlayerStats.max_missiles > 0
