extends Powerup


func pickup() -> void:
	super()
	PlayerStats.max_missiles += 3
	PlayerStats.missiles = PlayerStats.max_missiles
