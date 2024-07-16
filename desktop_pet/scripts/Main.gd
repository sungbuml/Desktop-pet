extends Node2D

@onready var _MainWindow: Window = get_window()

@export var player_size: Vector2i = Vector2i(32, 32)  # Should be the size of your character sprite, or slightly bigger
@export var pet: AnimatedSprite2D
@export var window:PackedScene

var screen_height: int = DisplayServer.screen_get_usable_rect().size.y
var screen_width: int = DisplayServer.screen_get_usable_rect().size.x

# Movement variables
var speed = 2
var dir = -1
var walking = false
var move_vector: Vector2i

var timer: float = 0.0
var decision_cd: float = 3.0

var window_y_pos: int = 0

func _ready():
	# Settings that cannot be set in project settings
	_MainWindow.transparent_bg = true  # Make the window's background transparent
	#_MainWindow.mouse_passthrough = true  # Allow the mouse to pass through the window

	_MainWindow.min_size = player_size * Vector2i(get_node("Sprite/Camera2D").zoom)
	_MainWindow.size = _MainWindow.min_size


	window_y_pos = screen_height - _MainWindow.size.y
	_MainWindow.position = Vector2i(int(screen_width / 2.0 - player_size.x / 2.0), window_y_pos)

	move_vector = Vector2i(-speed, 0)


func _physics_process(delta):
	check_input()
	timer += delta
	if timer > decision_cd:
		timer = 0.0
		decide_behavior()

	behavior()
	

func check_input():
	if Input.is_action_just_pressed("right_click"):
		if pet.position.x - player_size.x/2 < get_global_mouse_position().x and get_global_mouse_position().x < pet.position.x + player_size.x/2:
			if pet.position.y - player_size.y/2 < get_global_mouse_position().y and get_global_mouse_position().y < pet.position.y + player_size.y/2:
				print("Clicked on pet")
				var newWindow = window.instantiate()
				_MainWindow.add_child(newWindow)

				# connect signals
				newWindow.connect("reset", _on_reset)
				newWindow.connect("higher", _on_higher)
				newWindow.connect("lower", _on_lower)


func _on_reset():
	_MainWindow.position.y = window_y_pos

func _on_higher():
	_MainWindow.position.y -= 10

func _on_lower():
	_MainWindow.position.y += 10





func behavior():
	if walking:
		pet.play("walk")

		if _MainWindow.position.x <= (0 + player_size.x / 2.0) or _MainWindow.position.x >= (screen_width - player_size.x / 2.0):
			change_dir()

		_MainWindow.position += Vector2i(move_vector)

	else:
		pet.play("default")

func decide_behavior():
	var random = randi() % 4
	if random < 3:
		if random == 0:
			change_dir()
		walking = true
	else:
		walking = false

func change_dir():
	pet.flip_h = !pet.flip_h
	dir *= -1
	move_vector = Vector2i(speed, 0) * dir