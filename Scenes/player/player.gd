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

func _ready() -> void:
	jumps_left = max_jumps
	
func _physics_process(delta: float) -> void:
	if not can_move:
		return
	handle_movement()
	handle_gravity(delta)
	handle_wall_collision()
	hande_jump_input()
	move_and_slide()
	
func handle_movement() -> void:
	velocity.x = move_direction * max_speed
	if is_on_floor():
		anim_sprite.play("run")
		jumps_left = max_jumps
		
func handle_gravity(delta: float) -> void:
	if not  is_on_floor():
		velocity.y += gravity * delta
		
func handle_wall_collision() -> void:
	if not ray_cast.is_colliding():
		return
		
	velocity.y = 50
	jumps_left = max_jumps
	anim_sprite.play("fall")
	
	if is_on_floor():
		change_direction()
		
func change_direction() -> void:
	move_direction *= -1
	visuals.scale.x *= -1

func hande_jump_input() -> void:
	if not Input.is_action_just_pressed("tap"):
		return
	
	if ray_cast.is_colliding():
		change_direction()
		jump()
	else:
		jump()
	
func jump() -> void:
	if jumps_left <= 0:
		return
	
	velocity.y = -jump_force
	jumps_left -= 1
	if jumps_left <= 0:
		anim_sprite.play("double_jump")
	else:
		anim_sprite.play("jump")

func player_dead() -> void:
	can_move = false
	velocity = Vector2.ZERO
	anim_sprite.play("dead")
	collision_shape_2d.set_deferred("disabled",true)
	
func player_respawn() -> void:
	anim_sprite.play("respawn")
	await anim_sprite.animation_finished
	can_move = true
	collision_shape_2d.set_deferred("disabled",false)
