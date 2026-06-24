extends Node2D

@export var radius := 33.0
var dragging := false
var previous_angle := 0.0
var target_rotation := 0.0
var speed_factor := 10.0

func _process(delta):
	if !dragging:
		return
	var direction = get_global_mouse_position() - global_position
	var current_angle = direction.angle()
	var delta_angle = wrapf(current_angle - previous_angle,-PI,	PI)
	target_rotation += delta_angle
	rotation = lerp_angle(rotation,target_rotation,10.0 * delta)
	EventManager.rotate_red_obstacles.emit(delta_angle * speed_factor * delta)
	previous_angle = current_angle


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var distance = global_position.distance_to(get_global_mouse_position())
				if distance <= radius:
					dragging = true
					var direction = (get_global_mouse_position()- global_position)
					previous_angle = direction.angle()
			else:
				dragging = false
