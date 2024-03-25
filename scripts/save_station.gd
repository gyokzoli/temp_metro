extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_2d_body_entered(player: Node2D) -> void:
	if not player is Player: return
	PlayerStats.refill()
	Sound.play(Sound.powerup, 0.6, -10)
	SaveManager.save_game()
	animation_player.play("save")
