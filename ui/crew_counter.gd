extends Label


func _ready():
	GameEvent.connect("crew_count", Callable(self, "_crew_count"))

func _crew_count(count):
	text = "Crew: " + str(count)
	print("test")
