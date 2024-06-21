extends CanvasLayer

var palette: Texture2D:
	get:
		return ((get_node("ColorRect") as Control).material as ShaderMaterial).get_shader_parameter(&"u_palette")
	set(v):
		((get_node("ColorRect") as Control).material as ShaderMaterial).set_shader_parameter(&"u_palette",v)
