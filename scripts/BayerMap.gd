@tool
class_name BayerMapTexture
extends ImageTexture

@export_range(0,8) var size := 1:
	set(v):
		size=v
		_update_size()

func _generate_image(size: int) -> Image:
	var img : Image
	if (size == 1):
		img = Image.create(2,2,true,Image.FORMAT_L8)
		img.set_pixel(0,0,Color(0,0,0))
		img.set_pixel(1,0,Color(.5,.5,.5))
		img.set_pixel(0,1,Color(.75,.75,.75))
		img.set_pixel(1,1,Color(.25,.25,.25))
		return img
	if (size==0):
		return Image.create(1,1,false,Image.FORMAT_L8)
	img = Image.create(2**size,2**size,true,Image.FORMAT_L8)
	var smaller_img := _generate_image(size-1)
	for ix in range(0,2):
		for iy in range(0,2):
			var iv: int
			match ix+iy*2:
				0:iv=0
				1:iv=2
				2:iv=3
				3:iv=1
			for x in range(0,2**size/2):
				for y in range(0,2**size/2):
					var v: float = smaller_img.get_pixel(x,y).r+float(iv)/(4**size)
					img.set_pixel(ix*2**size/2+x,iy*2**size/2+y,Color(v,v,v))
	return img

func _init():
	await Engine.get_main_loop().process_frame
	_update_size()

func _update_size() -> void:
	var img := _generate_image(size)
	set_image(img)
