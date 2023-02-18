extends KinematicBody2D

# Player movement
export var ACCELERATION = 100
export var FRICTION = 50
export var SPEED = 300
onready var sprite = get_node("Sprite")
onready var timer = $RefreshTimer

var velocity = Vector2.ZERO

# Bullet preload
var bullet = preload("res://Entities/Bullet.tscn")

# End game preload
var endgame = preload("res://UI/PlayAgain.tscn")


func _ready():
	add_to_group("enemy_killed")


func _physics_process(_delta):
	var input_vector = Vector2.ZERO

	look_at(get_global_mouse_position())
	if get_global_mouse_position().x < position.x:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("mouse_left"):
		fire()


func death():
	load_endgame("Lost")


func enemy_killed():
	var enemies_remaining = get_parent().get_node("Enemies").get_child_count()
	if enemies_remaining == 0:
		load_endgame("Won")


func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.initialize(get_global_position(), rotation_degrees)
	get_parent().add_child(bullet_instance)


func load_endgame(status):
	var engame_instance = endgame.instance()
	engame_instance.initialize(status)
	get_tree().get_root().add_child(engame_instance)
	var _return = get_tree().change_scene_to(engame_instance)


func _on_HitBox_body_entered(_body):
	death()


func _on_RefreshTimer_timeout():
	enemy_killed()
