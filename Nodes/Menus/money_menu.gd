extends Control

@onready var label_money = $LabelMoney

func update_money(money : float):
	label_money.text = str(snapped(money, 0.01)) + '€'
