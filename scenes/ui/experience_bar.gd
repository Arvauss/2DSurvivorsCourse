extends CanvasLayer


@export var experience_manager : Node
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_update)
	
	
func on_experience_update(current_experience : float, target_experience: float):
	if current_experience == 0:
		progress_bar.value = 0
	var percent = current_experience / target_experience
	progress_bar.value = percent
