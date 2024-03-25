extends Node

@export var main_theme: AudioStream
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func play(song: AudioStream, from_position: float = 0.0) -> void:
	audio_stream_player.stream = song
	audio_stream_player.play(from_position)

func fade(duration: float = 1.0) -> void:
	var previous_volume_db: float = audio_stream_player.volume_db
	var volume_fade: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	volume_fade.tween_property(audio_stream_player, "volume_db", -50.0, duration).from_current()
	await volume_fade.finished
	audio_stream_player.stop()
	audio_stream_player.volume_db = previous_volume_db

