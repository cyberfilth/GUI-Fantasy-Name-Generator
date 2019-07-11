extends Node2D

onready var resultsbox = get_node("VBoxContainer/ResultsBox")
onready var alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
var names = []
var markov = {}
# Name for Dwarven clan
const CLAN_FIRSTPART = []
const CLAN_SECONDPART = []
# Elven city
const ELF_NAME1 = []
const ELF_NAME2 = []

func _ready():
	randomize()
	# load Markov names
	var markovfile = File.new()
	var filepath1 = "res://markov_list.txt"
	if !markovfile.file_exists(filepath1):
		OS.alert("Cannot find markov_list.txt")
		return ERR_FILE_NOT_FOUND
	var opened = markovfile.open(filepath1, File.READ)
	# Alert and return error if file can't be opened
	if !opened == OK:
		OS.alert("Unable to access markov_list.txt")
		return opened
	while not markovfile.eof_reached():
		for l in markovfile.get_csv_line():
			names.append(l)
	# load Dwarven names
	var dwarfile1 = File.new()
	var filepath2 = "res://dwarven1.txt"
	if !dwarfile1.file_exists(filepath2):
		OS.alert("Cannot find dwarven1.txt")
		return ERR_FILE_NOT_FOUND
	var opened2 = dwarfile1.open(filepath2, File.READ)
	# Alert and return error if file can't be opened
	if !opened2 == OK:
		OS.alert("Unable to access dwarven1.txt")
		return opened2
	while not dwarfile1.eof_reached():
		for l in dwarfile1.get_csv_line():
			CLAN_FIRSTPART.append(l)
	var dwarfile2 = File.new()
	var filepath3 = "res://dwarven2.txt"
	if !dwarfile2.file_exists(filepath3):
		OS.alert("Cannot find dwarven2.txt")
		return ERR_FILE_NOT_FOUND
	var opened3 = dwarfile2.open(filepath3, File.READ)
	# Alert and return error if file can't be opened
	if !opened3 == OK:
		OS.alert("Unable to access dwarven2.txt")
		return opened3
	while not dwarfile2.eof_reached():
		for l in dwarfile2.get_csv_line():
			CLAN_SECONDPART.append(l)
		# load Elven names
	var elffile1 = File.new()
	var filepath4 = "res://elven1.txt"
	if !elffile1.file_exists(filepath4):
		OS.alert("Cannot find elven1.txt")
		return ERR_FILE_NOT_FOUND
	var opened4 = elffile1.open(filepath4, File.READ)
	# Alert and return error if file can't be opened
	if !opened4 == OK:
		OS.alert("Unable to access elven1.txt")
		return opened4
	while not elffile1.eof_reached():
		for l in elffile1.get_csv_line():
			ELF_NAME1.append(l)
	var elffile2 = File.new()
	var filepath5 = "res://elven2.txt"
	if !elffile2.file_exists(filepath5):
		OS.alert("Cannot find elven2.txt")
		return ERR_FILE_NOT_FOUND
	var opened5 = elffile2.open(filepath5, File.READ)
	# Alert and return error if file can't be opened
	if !opened5 == OK:
		OS.alert("Unable to access elven2.txt")
		return opened5
	while not elffile2.eof_reached():
		for l in elffile2.get_csv_line():
			ELF_NAME2.append(l)
	
	# Start
	_on_Markov_pressed()

func loadNames(markov, names):
	for name in names:
		var currName = name
		for i in range(currName.length()):
			var currLetter = currName[i].to_lower()
			var letterToAdd;
			if i == (currName.length() - 1):
				letterToAdd = "."
			else:
				letterToAdd = currName[i+1]
			var tempList = []
			if markov.has(currLetter):
				tempList = markov[currLetter]
			tempList.append(letterToAdd)
			markov[currLetter] = tempList

func getName (firstChar, minLength, maxLength):
	var count = 1
	var name = ""
	if firstChar:
		name += firstChar
	else:
		var random_letter = alphabet[roll(0, alphabet.size()-1)]
		name += random_letter
	while count < maxLength:
		var new_last = name.length()-1
		var nextLetter = getNextLetter(name[new_last])
		if str(nextLetter) == ".":
			if count > minLength:
				return name
		else:
			name += str(nextLetter)
			count+=1
	return name

func getNextLetter(letter):
	var thisList = markov[letter]
	return thisList[roll(0, thisList.size()-1)]

# Random number generator
func roll(l,h):
	return int(round(rand_range(l,h)))


func _on_Markov_pressed():
	var maxnum = get_node("VBoxContainer/chooseNumber/SpinBox").get_value()
	loadNames(markov, names)
	var populated_list = ""
	var new_name = ""
	for i in range(20):
		var random_letter = alphabet[roll(0, alphabet.size()-1)]
		new_name = getName(random_letter, 4, maxnum)
		new_name = new_name.capitalize()
		populated_list += new_name+"\n"
	resultsbox.set_text(populated_list)


func _on_Dwarf_pressed():
	var dwarf_clan_name = ""
	var new_clan = ""
	for n in range(10):
		new_clan = "The Dwarven "+CLAN_FIRSTPART[randi() % CLAN_FIRSTPART.size()] + CLAN_SECONDPART[randi() % CLAN_SECONDPART.size()]+" clan\n"
		dwarf_clan_name += new_clan
	resultsbox.set_text(dwarf_clan_name)

func _on_Elf_pressed():
	var elven_city = ""
	var new_city = ""
	for p in range(10):
		new_city = ELF_NAME1[randi() % ELF_NAME1.size()] + ELF_NAME2[randi() % ELF_NAME2.size()]+"\n"
		elven_city += new_city
	resultsbox.set_text(elven_city)

func _on_Export_pressed():
	var savefile = File.new()
	var saveopened = savefile.open("res://Exported_Names.txt", File.WRITE)
	# Alert and return error if file can't be opened
	if not saveopened == OK:
		OS.alert("Unable to access save file")
		return saveopened
	# Gather names to save
	var exportdata = resultsbox.get_text()
	savefile.store_string(exportdata)
	savefile.close()
	return saveopened

func _on_Quit_pressed():
	get_tree().quit()
