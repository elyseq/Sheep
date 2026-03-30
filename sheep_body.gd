extends CharacterBody2D

@export var speed = 80

var direction = -1

func _ready():
	$animatedSheep.play("walk")

func _physics_process(delta):

	velocity.x = speed * direction

	move_and_slide()

	if is_on_wall():
		direction *= -1
		
		if direction == 1:
			$animatedSheep.flip_h = true
		else:
			$animatedSheep.flip_h = false
