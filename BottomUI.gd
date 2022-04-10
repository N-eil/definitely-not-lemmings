extends MarginContainer

signal element_choice

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    for child in $Bottomstuff/Hotbar.get_children():
        if child is VBoxContainer:
           connect("element_choice", child, "set_active")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _on_magic_GUI_input(event):
    if event is InputEventMouseButton && event.pressed:
        print(event)
        emit_signal("element_choice", false)
