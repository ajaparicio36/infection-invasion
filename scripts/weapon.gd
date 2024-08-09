extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var barrel = $Barrel
var Bullet = preload("res://scenes/projectile.tscn")
var weapon
var can_fire = true
var fire_timer = 0.0

class Weapon:
	var name: String
	var penetrate: bool
	var fire_rate: float
	var damage: int
	var bullet_count: int = 1
	var spread: float = 0.0
	var ammo: int
	func _init(_name: String, _penetrate: bool, _ammo: int, _fire_rate: float, _damage: int, _bullet_count: int = 1, _spread: float = 0.0):
		name = _name
		penetrate = _penetrate
		fire_rate = _fire_rate
		damage = _damage
		bullet_count = _bullet_count
		spread = _spread
		ammo = _ammo

var weapons = {
	"Pistol": Weapon.new("Pistol", false, 100000000000, 0.3, 20),
	"Rifle": Weapon.new("Rifle", false, 100, 0.1, 30),
	"Shotgun": Weapon.new("Shotgun", false, 12, 0.8, 50, 5, 0.4),
	"Sniper": Weapon.new("Sniper", true, 3, 1, 100)
}

signal take_damage(lost_hp)
signal set_weapon(new_weapon)
signal set_ammo(new_ammo)
signal bullet_hit(damage: int, enemy_id: int)

func _ready():
	change_weapon("Pistol")

func change_weapon(weapon_name: String):
	var chosen_weapon = weapons[weapon_name]
	if chosen_weapon.ammo != 0:
		weapon = weapons[weapon_name]
		emit_signal("set_weapon", weapon.name)
		emit_signal("set_ammo", weapon.ammo)

func shoot():
	if weapon.bullet_count == 1:
		var bullet = create_bullet(barrel.global_rotation)
		get_tree().current_scene.add_child(bullet)
	else:
		for i in range(weapon.bullet_count):
			var spread_angle = lerp(-weapon.spread, weapon.spread, float(i) / (weapon.bullet_count - 1))
			var bullet = create_bullet(barrel.global_rotation + spread_angle)
			get_tree().current_scene.add_child(bullet)
	
	weapon.ammo -= 1
	emit_signal("set_ammo", weapon.ammo)

func create_bullet(rotation):
	var bullet = Bullet.instantiate()
	bullet.position = barrel.global_position
	bullet.direction = Vector2.UP.rotated(rotation)
	bullet.scale = Vector2(0.07, 0.07)
	bullet.damage = weapon.damage
	bullet.connect("hit", Callable(self, "_on_bullet_hit"))
	return bullet

func _on_bullet_hit(damage: int, enemy_id: int):
	emit_signal("bullet_hit", damage, enemy_id)
	print("Bullet hit enemy " + str(enemy_id) + " for " + str(damage) + " damage")

func add_ammo(weapon_name, amount: int):
	var chosen_weapon = weapons[weapon_name]
	chosen_weapon.ammo += amount

func _process(delta):
	for weapon_name in weapons.keys():
		if Input.is_action_pressed(weapon_name.to_lower()) and weapon.name != weapon_name:
			change_weapon(weapon_name)
			break
	
	if weapon.ammo == 0:
		change_weapon("Pistol")
	
	if Input.is_action_pressed("shoot") and can_fire:
		shoot()
		can_fire = false
		fire_timer = weapon.fire_rate
	
	if not can_fire:
		fire_timer -= delta
		if fire_timer <= 0:
			can_fire = true
