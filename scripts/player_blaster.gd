extends Node2D

const BulletScene: PackedScene = preload("res://scenes/bullet.tscn")

@onready var blaster_sprite_2d: Sprite2D = $BlasterSprite2D
@onready var muzzle: Marker2D = $BlasterSprite2D/Muzzle


func _process(_delta) -> void:
	blaster_sprite_2d.rotation = get_local_mouse_position().angle()

func fire_bullet() -> void:
	var bullet = Utils.instantiate_scene_on_world(BulletScene, muzzle.global_position)
	bullet.rotation = blaster_sprite_2d.rotation
	bullet.update_velocity()
