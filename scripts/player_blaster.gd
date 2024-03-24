extends Node2D

const BulletScene: PackedScene = preload("res://scenes/bullet.tscn")
const MissileScene: PackedScene = preload("res://scenes/missile.tscn")

@onready var blaster_sprite_2d: Sprite2D = $BlasterSprite2D
@onready var muzzle: Marker2D = $BlasterSprite2D/Muzzle


func _process(_delta) -> void:
	blaster_sprite_2d.rotation = get_local_mouse_position().angle()

func fire_bullet() -> void:
	var bullet: Node2D = Utils.instantiate_scene_on_level(BulletScene, muzzle.global_position)
	bullet.rotation = blaster_sprite_2d.rotation
	bullet.update_velocity()

func fire_missile() -> void:
	var missile: Node2D = Utils.instantiate_scene_on_level(MissileScene, muzzle.global_position)
	missile.rotation = blaster_sprite_2d.rotation
	missile.update_velocity()
