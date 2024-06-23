class_name Tea extends Node

const CHAI_TEA = {"sweetness":+2,"flavor":+2}
const WHITE_TEA = {"flavor":-2,"herbaceousness":-2}
const BLACK_TEA = {"sweetness":-2,"herbaceousness":-2}
const ROOIBOS_TEA = {"sweetness":+2,"herbaceousness":-2}
const GREEN_TEA = {"sweetness":+1,"flavor":+1,"herbaceousness":-1}

const CINNAMON = {"sweetness":-1,"flavor":+1}
const MILK = {"sweetness":+1,"flavor":-1}
const JASMINE = {"herbaceousness":-1,"flavor":-1}
const MINT = {"herbaceousness":+1,"sweetness":-1}
const SUGAR = {"sweetness":+1}
const LEMON_SLICE = {"flavor":+1}

static func get_item_name(x: Dictionary)->StringName:
	match x:
		CHAI_TEA:
			return &"Chai Tea Base"
		WHITE_TEA:
			return &"White Tea Base"
		BLACK_TEA:
			return &"Black Tea Base"
		ROOIBOS_TEA:
			return &"Rooibos Tea Base"
		GREEN_TEA:
			return &"Green Tea Base"
		CINNAMON:
			return &"Cinnamon"
		MILK:
			return &"Milk"
		JASMINE:
			return &"Jasmine"
		MINT:
			return &"Mint"
		SUGAR:
			return &"Sugar"
		LEMON_SLICE:
			return &"Lemon Slice"
		_:
			return &"unknown"

@export_category("Mix")
@export var tea_mix := []

func get_mix_names()->Array[StringName]:
	var a: Array[StringName] = []
	for i in tea_mix:
		a.append(get_item_name(i))
	return a

@export_category("Stats")
@export var sweetness := 0
@export var flavor := 0
@export var herbaceousness := 0

func update_stats()->void:
	sweetness = 0
	flavor = 0
	herbaceousness = 0
	for i: Dictionary in tea_mix:
		sweetness += i.get("sweetness",0)
		flavor += i.get("flavor",0)
		herbaceousness += i.get("herbaceousness",0)
