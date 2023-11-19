	### player.gd

extends CharacterBody2D

# Player movement speed
@export var speed = 50
var is_jumping = false

# Node references
@onready var animation_sprite = $AnimatedSprite2D

#direction and animation to be updated throughout game state
var new_direction = Vector2(0,1) #only move one spaces
var animation

func _physics_process(delta):
	# Get player input (left, right, up/down)
	var direction: Vector2
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
		
	if Input.is_action_pressed("sprint"):
		speed = 100
	elif Input.is_action_just_released("sprint"):
		speed = 50

	# Apply movement
	var movement = speed * direction * delta
	
#	if !is_jumping:
#		move_and_collide(movement)
#		player_animations()
	if !Input.is_anything_pressed():
		if !is_jumping:
			animation = "idle_sit"
			returned_direction(new_direction)
	
	# Moves our player around, whilst enforcing collisions so that they come to a stop when colliding with another object.
	move_and_collide(movement)
	#plays animations
	player_animations(direction)
	
# Animations
func player_animations(direction : Vector2):
	#Vector2.ZERO is the shorthand for writing Vector2(0, 0).
	if !is_jumping:
		if direction != Vector2.ZERO:
			#update our direction with the new_direction
			new_direction = direction
			#play walk animation, because we are moving
			animation = "walk"
			returned_direction(new_direction)
			#animation = "walk_" + returned_direction(new_direction)
			animation_sprite.play(animation)
		else:
			#play idle animation, because we are still
			animation = "idle_sit"
			#animation  = "idle_" + returned_direction(new_direction)
			returned_direction(new_direction)
		animation_sprite.play(animation)

# Animation Direction
func returned_direction(direction : Vector2):
	#it normalizes the direction vector 
	var normalized_direction  = direction.normalized()
	var default_return = "side"

	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
	elif normalized_direction.x > 0:
		#(right)
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x < 0:
		#flip the animation for reusability (left)
		$AnimatedSprite2D.flip_h = true
		return "side"

	#default value is empty
	return default_return
	
func _input(event):
	
	if event.is_action_pressed("jump"):
		is_jumping = true
		var animation = "jump"
		returned_direction(new_direction)
		animation_sprite.play(animation)


func _on_animated_sprite_2d_animation_finished():
	is_jumping = false
