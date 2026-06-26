extends CharacterBody2D
class_name Player

@export var max_speed := 180.0
@export var jump_force := 450.0
@export var max_jumps := 2
@export var gravity := 1600.0

@onready var visuals: Node2D = $Visuals
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var ray_cast: RayCast2D = %RayCast2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var jumps_left : int
var move_direction := 1
var can_move := true
var taking_damage := false
var fly_mode := false

func _ready() -> void:
	jumps_left = max_jumps
	
func _physics_process(delta: float) -> void:
	if not can_move:
		return
	if fly_mode:
		handle_flight(delta)
	else:
		handle_movement()
		handle_gravity(delta)
		hande_jump_input()
	handle_wall_collision()
	move_and_slide()
	
func handle_movement() -> void:
	if taking_damage:
		return
	#velocity.x = move_direction * max_speed
	var direction = Input.get_axis("keyboard_left", "keyboard_right")
	if direction:
		change_direction(direction)
		velocity.x = move_toward(velocity.x, direction * max_speed, max_speed * 10)
	else:
		velocity.x = move_toward(velocity.x, 0, max_speed)

	if is_on_floor():
		if abs(velocity.x) > 1:
			anim_sprite.play("run")
		else:
			anim_sprite.play("idle")
			jumps_left = max_jumps
	
func handle_flight(delta):
	var x = Input.get_axis("keyboard_left", "keyboard_right")
	var y = Input.get_axis("keyboard_up", "keyboard_down")
	velocity.x = x * max_speed
	velocity.y = y * max_speed
	if is_on_floor():
		fly_mode = false
		jumps_left = max_jumps
	
func handle_gravity(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		
func handle_wall_collision() -> void:
	if not ray_cast.is_colliding():
		return
		
	velocity.y = 50
	jumps_left = max_jumps
		
func change_direction(direction) -> void:
	move_direction = direction
	visuals.scale.x = direction
	
func change_direction_jump() -> void:
	move_direction *= -1
	visuals.scale.x *= -1

func hande_jump_input() -> void:
	if not Input.is_action_just_pressed("keyboard_jump"):
		return
	
	if ray_cast.is_colliding():
		change_direction_jump()
		jump()
	else:
		jump()
	
func jump() -> void:
	if fly_mode:
		return
	if jumps_left == max_jumps:
		velocity.y = -jump_force
		jumps_left -= 1
		anim_sprite.play("jump")
	else:
		fly_mode = true
		anim_sprite.play("fly")

func player_dead() -> void:
	can_move = false
	velocity = Vector2.ZERO
	anim_sprite.play("dead")
	collision_shape_2d.set_deferred("disabled",true)
	
func player_damage() -> void:
	if taking_damage:
		return
	taking_damage = true
	anim_sprite.play("hit")
	await anim_sprite.animation_finished
	taking_damage = false
	
func player_respawn() -> void:
	anim_sprite.play("respawn")
	await anim_sprite.animation_finished
	can_move = true
	collision_shape_2d.set_deferred("disabled",false)
