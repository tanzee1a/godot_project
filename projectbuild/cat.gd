extends CharacterBody2D

@onready var anim_sprite = $AnimatedSprite2D
@onready var timer = $Timer

const speed = 50
var current_state = IDLE
var dir = Vector2.RIGHT
var start_pos: Vector2

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	timer.wait_time = choose([0.5, 1, 1.5])
	timer.start()

func _process(delta):
	match current_state:
		IDLE:
			if anim_sprite.animation != "idle":
				anim_sprite.play("idle")
		NEW_DIR:
			dir = choose([Vector2.RIGHT, Vector2.LEFT])
			current_state = MOVE
		MOVE:
			move(delta)
			if anim_sprite.animation != "walk":
				anim_sprite.play("walk")

func move(delta):
	position += dir * speed * delta
	if position.x >= start_pos.x + 50:
		position.x = start_pos.x + 50
		dir = Vector2.LEFT
	elif position.x <= start_pos.x - 50:
		position.x = start_pos.x - 50
		dir = Vector2.RIGHT

	# Flip the sprite depending on the direction
	anim_sprite.flip_h = dir == Vector2.LEFT

func choose(array):
	array.shuffle()
	return array[0]

func _on_timer_timeout():
	timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR])

