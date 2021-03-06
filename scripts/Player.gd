extends "res://scripts/Actor.gd"

class_name Player

var controlling: bool = false
var can_shoot_rockets: bool = false
var can_shoot: bool = false
var rockets: int = 3
const projectile: PackedScene = preload("res://scenes/Projectile.tscn")

signal shoot
signal rocket_added

func take_damage(damage: int) -> void:
	if health <= 0: return # Already dead
	if not GameMeta.player_can_take_damage: return
	health -= damage
	anim_player.play("death")
	controlling = false
	anim_player.play("death")
	emit_signal("died")

# Returns a normalized input vector.
func get_input_vector() -> Vector2:
	var vec = Vector2(0,0)

	if Input.is_action_pressed("up"): vec.y -= 1
	if Input.is_action_pressed("down"): vec.y += 1
	if Input.is_action_pressed("right"): vec.x += 1
	if Input.is_action_pressed("left"): vec.x -= 1

	return vec.normalized()

func turn_on_flashlight() -> void:
	$FlashlightHolder/Flashlight.on()

func play_if_moving(vector: Vector2) -> void:
	if vector.length() <= 0: return

	if $DelayBetweenWalks.is_stopped():
		var pitch: float = rand_range(0.3, 1.9)
		$WalkPlayer.pitch_scale = pitch
		$WalkPlayer.play()
		$DelayBetweenWalks.start()

func equip_flashlight() -> void:
	var flashlight = load("res://scenes/Flashlight.tscn")
	$FlashlightHolder.add_child(flashlight.instance())

func _physics_process(_delta: float) -> void:
	if not controlling: return

	# Move
	var vel: Vector2 = move_and_slide(get_input_vector() * movement_speed)
	play_anim(vel)
	play_if_moving(vel)

	# Shoot
	if Input.is_action_just_pressed("shoot") and can_shoot:
		$ThrowPlayer.play()
		var proj: Projectile = projectile.instance()
		proj.global_position = global_position
		emit_signal("shoot", proj)
		get_tree().set_input_as_handled()

	# Rocket
	if Input.is_action_just_pressed("add_rocket") and can_shoot_rockets:
		if rockets > 0:
			rockets -= 1
			controlling = false
			emit_signal("rocket_added")
			get_tree().set_input_as_handled()
