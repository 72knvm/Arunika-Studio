extends RefCounted

const UI_THEME=preload("res://assets/themes/pixelify.tres")
const FONT_FILE=preload("res://assets/fonts/pixelify.ttf")
const MENU_START_Y := 382.0
const MENU_ROW_HEIGHT := 65.0

static func build(interface: CanvasLayer) -> Dictionary:
	var menu_controls: Control
	var title: Label
	var subtitle: Label
	var menu_buttons: Array[Button]=[]
	menu_controls=Control.new()
	menu_controls.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu_controls.theme=UI_THEME
	interface.add_child(menu_controls)
	var scrim:=ColorRect.new()
	scrim.size=Vector2(860,941)
	scrim.mouse_filter=Control.MOUSE_FILTER_IGNORE
	var scrim_material:=ShaderMaterial.new()
	var scrim_shader:=Shader.new()
	scrim_shader.code="shader_type canvas_item; void fragment(){ COLOR=vec4(0.025,0.04,0.085,0.57*(1.0-smoothstep(0.12,1.0,UV.x))); }"
	scrim_material.shader=scrim_shader
	scrim.material=scrim_material
	menu_controls.add_child(scrim)
	var title_font:=FontVariation.new()
	title_font.base_font=FONT_FILE
	title_font.variation_opentype={"wght":600.0}
	title=Label.new()
	title.position=Vector2(112,80)
	title.size=Vector2(730,240)
	title.text="KALA"
	title.add_theme_font_override("font",title_font)
	title.add_theme_font_size_override("font_size",208)
	title.add_theme_color_override("font_shadow_color",Color(0.02,0.03,0.07,0.7))
	title.add_theme_constant_override("shadow_offset_x",3)
	title.add_theme_constant_override("shadow_offset_y",3)
	menu_controls.add_child(title)
	subtitle=Label.new()
	subtitle.position=Vector2(112,288)
	subtitle.size=Vector2(730,62)
	subtitle.text="Singkap Garis Waktu"
	subtitle.add_theme_font_override("font",UI_THEME.get_font("font","Button"))
	subtitle.add_theme_font_size_override("font_size",44)
	subtitle.add_theme_color_override("font_color",Color(0.92,0.89,0.82,1))
	subtitle.add_theme_color_override("font_shadow_color",Color(0.02,0.03,0.07,0.7))
	subtitle.add_theme_constant_override("shadow_offset_x",2)
	subtitle.add_theme_constant_override("shadow_offset_y",2)
	menu_controls.add_child(subtitle)
	var labels=["Lanjutkan","New Game","Load Game","Settings","Credits","Exit"]
	for i in range(labels.size()):
		var button:=Button.new()
		button.name="MenuButton%d"%i
		button.text=labels[i]
		button.position=Vector2(112,MENU_START_Y+i*MENU_ROW_HEIGHT)
		button.size=Vector2(490,58)
		button.alignment=HORIZONTAL_ALIGNMENT_LEFT
		button.disabled=i==0
		menu_controls.add_child(button)
		menu_buttons.append(button)
	menu_buttons[1].grab_focus()
	return {"controls":menu_controls,"title":title,"subtitle":subtitle,"buttons":menu_buttons}


static func set_save_available(buttons: Array[Button], available: bool) -> void:
	buttons[0].visible = available
	buttons[0].disabled = not available
	buttons[2].disabled = not available
	var row := 0
	for button in buttons:
		if button.visible:
			button.position.y = MENU_START_Y + row * MENU_ROW_HEIGHT
			row += 1
