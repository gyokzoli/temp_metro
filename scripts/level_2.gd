extends Node2D

@onready var bricks: Node2D = $Bricks
@onready var trigger: Area2D = $Trigger
@onready var brick_3: Brick = $Bricks/Brick3
@onready var brick_4: Brick = $Bricks/Brick4

func _ready() -> void:
	bricks.hide()
	#await Music.fade()
	#Music.play(Music.boss_theme)

func _on_trigger_trigger_entered() -> void:
	if not WorldStash.retrieve("firts_boss", "freed"):
		bricks.show()
		trigger.is_active = false

func _on_boss_enemy_tree_exited() -> void:
	brick_3.queue_free()
	brick_4.queue_free()
	trigger.is_active = false
