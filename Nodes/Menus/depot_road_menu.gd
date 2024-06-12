extends Control

@onready var slot_0 = $GridContainer/Slot0
@onready var slot_1 = $GridContainer/Slot1
@onready var slot_2 = $GridContainer/Slot2
@onready var slot_3 = $GridContainer/Slot3
@onready var slot_4 = $GridContainer/Slot4
@onready var slot_5 = $GridContainer/Slot5

var slots = [slot_0, slot_1, slot_2, slot_3, slot_4, slot_5]

func _ready():
	for child in self.get_children():
		print('Child')
	pass
