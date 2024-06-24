class_name Tea extends Node

const CHAI_TEA = {"sweetness":+2,"flavor":+2}
const WHITE_TEA = {"flavor":-2,"herbaceousness":-2}
const BLACK_TEA = {"sweetness":-2,"flavor":+2}
const ROOIBOS_TEA = {"sweetness":+2,"herbaceousness":-2}
const GREEN_TEA = {"sweetness":+1,"flavor":+1,"herbaceousness":+1}

const CINNAMON = {"sweetness":-1,"flavor":+1}
const MILK = {"sweetness":+1,"flavor":-1}
const JASMINE = {"herbaceousness":-1,"flavor":-1}
const MINT = {"herbaceousness":+1,"sweetness":-1}
const SUGAR = {"sweetness":+1}
const LEMON_SLICE = {"flavor":+1}

const TEA_BASES: Array[Dictionary] = [
	CHAI_TEA,BLACK_TEA,WHITE_TEA,ROOIBOS_TEA,GREEN_TEA
]
const ADDITIVES: Array[Dictionary] = [
	CINNAMON,MILK,JASMINE,MINT,SUGAR,LEMON_SLICE
]
const MAX_TEA_BASES_AMOUNT: int = 2
const MAX_ADDITIVES_AMOUNT: int = 1

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

var currentTeaBasesAmount: int = 0
var currentAdditivesAmount: int = 0

func add_to_tea_mix(ingredient: Dictionary):
	if ingredient in TEA_BASES:
		if currentTeaBasesAmount == MAX_TEA_BASES_AMOUNT:
		#cant do
			return false
		else:
			currentTeaBasesAmount += 1
	if ingredient in ADDITIVES:
		if currentAdditivesAmount == MAX_ADDITIVES_AMOUNT:
		#cant do
			return false
		else:
			currentAdditivesAmount += 1
	tea_mix.append(ingredient)
	sweetness += ingredient.get("sweetness",0)
	flavor += ingredient.get("flavor",0)
	herbaceousness += ingredient.get("herbaceousness",0)
	return true
	
func can_confirm_brew() -> bool:
	return currentTeaBasesAmount == MAX_TEA_BASES_AMOUNT and currentAdditivesAmount == MAX_ADDITIVES_AMOUNT
	

func update_stats()->void:
	sweetness = 0
	flavor = 0
	herbaceousness = 0
	for i: Dictionary in tea_mix:
		sweetness += i.get("sweetness",0)
		flavor += i.get("flavor",0)
		herbaceousness += i.get("herbaceousness",0)
		
func restart_brewing():
	sweetness = 0
	flavor = 0
	herbaceousness = 0
	tea_mix = []
	currentAdditivesAmount = 0
	currentTeaBasesAmount = 0

	
