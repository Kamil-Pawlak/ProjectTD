extends TextureButton

func on_mouse_entered():
	$ColorRect.visible = true
	
func on_mouse_left():
	$ColorRect.visible = false
