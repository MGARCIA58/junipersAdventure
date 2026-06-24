extends CharacterBody2D
class_name EnemyRino

@export var ray_lenght := 165.0
@export var move_speed := 50.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_ray_cast: RayCast2D = $WallRayCast
@onready var player_ray_cast: RayCast2D = $PlayerRayCast

var direction := 1
var can_move := false
var defeated := false

func _ready() -> void:
	player_ray_cast.target_position.x = ray_lenght
	
func _process(delta: float) -> void:
	if player_ray_cast.is_colliding():
		can_move = true
	
	if can_move:
		velocity.x = direction * move_speed
		anim_sprite.play("run")
		move_and_slide()
	
	if wall_ray_cast.is_colliding():
		can_move = false
		direction *= -1
		anim_sprite.play("hit_wall")
		await  get_tree().create_timer(0.8).timeout
		rotate_rino(direction)
		anim_sprite.play("idle")
		
func rotate_rino(direction: int) -> void:
	anim_sprite.scale.x = direction
	wall_ray_cast.scale.x = direction
	player_ray_cast.scale.x = direction


func _on_top_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	defeated = true
	can_move = false
	anim_sprite.play("hit")
	await get_tree().create_timer(1.2).timeout
	queue_free()


func _on_bottom_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
		
	if defeated:
		return
	EventManager.on_player_dead.emit()
