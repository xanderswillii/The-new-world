extends Control

@onready var rich_label: RichTextLabel = $PanelContainer2/VBoxContainer/RichTextLabel
@onready var speaker_label: Label = $PanelContainer2/VBoxContainer/Label
@onready var timer: Timer = $Timer2

var full_text: String = ""
var current_index: int = 0
var typing_speed: float = 0.05

signal dialogue_finished

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	hide()

func start_dialogue(text: String, speaker: String = "", speed: float = 0.05) -> void:
	full_text = text
	current_index = 0
	typing_speed = speed
	rich_label.bbcode_enabled = true
	rich_label.text = full_text
	rich_label.visible_characters = 0
	speaker_label.text = speaker
	speaker_label.visible = speaker != ""
	show()
	timer.wait_time = typing_speed
	timer.start()

func _on_timer_timeout() -> void:
	if current_index < full_text.length():
		current_index += 1
		rich_label.visible_characters = current_index
	else:
		timer.stop()
		emit_signal("dialogue_finished")

func skip_animation() -> void:
	timer.stop()
	current_index = full_text.length()
	rich_label.visible_characters = current_index
	emit_signal("dialogue_finished")

func close() -> void:
	hide()
	full_text = ""
	current_index = 0

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_accept"):
		if not timer.is_stopped():
			skip_animation()
		else:
			close()
