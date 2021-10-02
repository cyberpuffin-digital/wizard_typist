extends TextureButton

# youtube.com/watch?v=M0NK6QqVpSU
export (String) var text = "Text Button"
export(int) var margin_from_center = 100

func _ready():
	setup_text()
	show_arrows()
	set_focus_mode(true)

func setup_text():
	$RichTextLabel.bbcode_text = "[center]%s[/center]" % text
	
func show_arrows():
	for arrow in [$left_arrow, $right_arrow]:
		arrow.visible = true
		arrow.global_position.y = rect_global_position.y + (rect_size.y / 3.0)

	var center_x = rect_global_position.x + (rect_size.x / 2)
	$left_arrow.global_position.x = center_x - margin_from_center
	$right_arrow.global_position.x = center_x + margin_from_center
