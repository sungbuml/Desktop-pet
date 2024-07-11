extends Node2D

@onready var _MainWindow: Window = get_window()

@export var player_size: Vector2i = Vector2i(32, 32)  # Should be the size of your character sprite, or slightly bigger
@export var pet: AnimatedSprite2D

@export_node_path("Camera2D") var main_camera: NodePath
@onready var _MainCamera: Camera2D = get_node(main_camera)

var screen_height: int = DisplayServer.screen_get_size().y
var screen_width: int = DisplayServer.screen_get_usable_rect().size.x

var speed = 2
var dir = -1
var walking = false

var move_vector: Vector2i

var timer: float = 0.0
var decision_cd: float = 3.0


func _ready():
	# Settings that cannot be set in project settings
	_MainWindow.transparent_bg = true  # Make the window's background transparent
	#_MainWindow.mouse_passthrough = true  # Allow the mouse to pass through the window

	_MainWindow.min_size = player_size * Vector2i(_MainCamera.zoom)
	_MainWindow.size = _MainWindow.min_size

	_MainWindow.position = Vector2i(int(screen_width / 2.0 - player_size.x / 2.0), screen_height - _MainWindow.size.y - 32)

	move_vector = Vector2i(-speed, 0)


func _physics_process(delta):
	timer += delta
	if timer > decision_cd:
		timer = 0.0
		decide_behavior()

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
