extends Node2D

@onready var bubbly_blocks: TileMapLayer = $BubblyBlocks
@onready var spiral_blocks: TileMapLayer = $SpiralBlocks
@onready var escape_timer: Timer = $EscapeTimer
@onready var timer_label: Label = $CanvasLayer/TimerLabel

var escape_started: bool = false

func _ready() -> void:
	timer_label.visible = false
	# Starting state: BubblyBlocks pass-through, SpiralBlocks solid (both fully opaque)
	set_layer_active(bubbly_blocks, false)
	set_layer_active(spiral_blocks, true)

func _process(_delta: float) -> void:
	if escape_started:
		timer_label.text = "ESCAPE: %.1f" % escape_timer.time_left

func _on_appendix_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not escape_started:
		start_escape()

func start_escape() -> void:
	escape_started = true
	
	# Swap collisions: BubblyBlocks become SOLID, SpiralBlocks become PASS-THROUGH
	set_layer_active(bubbly_blocks, true)
	set_layer_active(spiral_blocks, false)
	
	if has_node("Appendix"):
		$Appendix.visible = false
	
	timer_label.visible = true
	escape_timer.start()

func set_layer_active(layer: TileMapLayer, is_solid: bool) -> void:
	layer.collision_enabled = is_solid
	if is_solid:
		layer.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		layer.process_mode = Node.PROCESS_MODE_DISABLED

func _on_escape_timer_timeout() -> void:
	get_tree().call_deferred("reload_current_scene")
