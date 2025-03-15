class_name TextOverlayPanel extends PanelContainer

@onready var text: Label = $Text
@onready var timer: Timer = $Timer

var text_labels: Array[String] = []
var wait_times: Array[float] = []

signal text_display_over

## Times is either an float (constant time for all text), or an array
## with wait times for each strings.
func display_text(strings: Array[String], times: float=1.0):
	visible = true
	text_labels = strings
	wait_times = []
	for i in range(strings.size()):
		wait_times.append(times)
	
	if not timer.timeout.is_connected(_on_timeout):
		timer.timeout.connect(_on_timeout)
	_on_timeout()

func _on_timeout():
	if text_labels.size() == 0:
		timer.timeout.disconnect(_on_timeout)
		timer.stop()
		visible = false
		text_display_over.emit()
	else:
		text.text = text_labels[0]
		text_labels.pop_front()
		timer.start(wait_times[0])
		wait_times.pop_front()
