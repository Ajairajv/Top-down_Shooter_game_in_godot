extends Control

func initialize(status):
	if status == "Won":
		$VBoxContainer/Label.text = "Good Job!  You won!"
	else:
		$VBoxContainer/Label.text = "You Died!"


func _on_Button_pressed():
	var _return = get_tree().change_scene("res://World.tscn")
	queue_free()
