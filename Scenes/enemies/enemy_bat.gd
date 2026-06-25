extends CharacterBody2D
class_name EnemyBat

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@export var path: CustomPathFollow
@export var health: int = 5
@export var touch_damage = 2
@export var player: Node2D
@export var body_in_area = false

var defeated := false
var top_jumped := false
var bottom_touched := false
var attacking := false

func _ready():
	print(timer)
	print(timer.wait_time)
	timer.timeout.connect(attack_player)
	
func _process(delta: float) -> void:
	anim_sprite.flip_h = path.direction == 1
	

func _on_top_area_body_entered(body: Node2D) -> void:
	if bottom_touched:
		return
	if body is Player:
		top_jumped = true
		anim_sprite.play("hit")
		body.velocity.y = -400
		health -= 1
		await anim_sprite.animation_finished
		#await get_tree().create_timer(0.5).timeout
		if health <= 0:
			path.can_move = false
			defeated = true
			queue_free()
		top_jumped = false



func _on_bottom_area_body_entered(body: Node2D) -> void:
	if defeated or top_jumped:
			return
	if body is Player:
		bottom_touched = true
		EventManager.on_player_damage.emit(touch_damage)
		await get_tree().create_timer(2).timeout
		bottom_touched = false
	


func _on_attack_area_body_entered(body: Node2D) -> void:
	if not body is Player: return
	if body_in_area: return
	body_in_area = true
	player = body
	timer.start()

func _on_attack_area_body_exited(body: Node2D) -> void:
	if not body is Player: return
	body_in_area = false
	timer.stop()
	

func attack_player() -> void:
	if not body_in_area:
		return
	if attacking:
		return
	attacking = true
	path.can_move = false
	var start_position = global_position
	var target_position = player.global_position
	var tween = create_tween()
	tween.tween_property(self,"global_position",target_position,0.4)
	tween.tween_interval(0.2)
	tween.tween_property(self,"global_position",start_position,0.4)
	await tween.finished
	path.can_move = true
	attacking = false
