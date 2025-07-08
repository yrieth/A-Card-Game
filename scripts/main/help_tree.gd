extends Tree

func _ready() -> void:
	columns = 1
	var root = create_item()
	hide_root = true
	var item1 = create_item(root)
	item1.set_text(0,"Multiplayer")
	item1.set_selectable(0, false)
	var item2 = create_item(item1)
	item2.set_text(0,"How to")
	item2.set_selectable(0, true)
	var item3 = create_item(root)
	item3.set_text(0, "Something else")
	var item4 = create_item(root)
	item4.set_text(0, "Not selectable")
	item4.set_selectable(0, false)


func update_article() -> void:
	pass
