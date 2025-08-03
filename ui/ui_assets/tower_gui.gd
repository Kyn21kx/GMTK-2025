class_name TowerGUI
extends Control

@export var atk_basic_active: StyleBoxTexture
@export var atk_magic_active: StyleBoxTexture

# @export var  

var slots_nodes: Array[Node]

func _ready() -> void:
	slots_nodes = %SlotContainer.get_children()

func set_active_slot(index: int):
	var prev_text := slots_nodes[(index - 1) % slots_nodes.size()] as TextureRect
	var text := slots_nodes[index] as TextureRect
	prev_text.texture = atk_basic_active.texture
	text.texture = atk_magic_active.texture
