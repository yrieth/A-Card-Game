extends Control

class Page extends Control:
	var cards: Array[Card]
	
	#func adopt_cards() -> void:
		#for card:Card in self.cards:
			#self.add_child(card)
		

const SLOTPOSITIONS: Array[Vector2] = [
	Vector2(64.0, 64.0),
	Vector2(64.0, 256.0),
	Vector2(64.0, 448.0),
	Vector2(192.0, 64.0),
	Vector2(192.0, 256.0),
	Vector2(192.0, 448.0),
	Vector2(320.0, 64.0),
	Vector2(320.0, 256.0),
	Vector2(320.0, 448.0),
	Vector2(448.0, 64.0),
	Vector2(448.0, 256.0),
	Vector2(448.0, 448.0),
	Vector2(576.0, 64.0),
	Vector2(576.0, 256.0),
	Vector2(576.0, 448.0),
	Vector2(704.0, 64.0),
	Vector2(704.0, 256.0),
	Vector2(704.0, 448.0),
	Vector2(832.0, 64.0),
	Vector2(832.0, 256.0),
	Vector2(832.0, 448.0)
]

@onready var currentPage:int = 0
@onready var maxPages:int = 0
var pages:Array[Page]


func _ready() -> void:
	var numCardsToDisplay:int = len(Global.COLLECTION)
	var numCardsDisplayed: int = 0
	var numCardsOnPage: int = 21
	var card:Card
	while numCardsDisplayed < numCardsToDisplay:
		
		if numCardsOnPage == 21:
			pages.append(Page.new())
			pages[maxPages].visible = false
			add_child(pages[maxPages])
			numCardsOnPage = 0
			maxPages += 1
		else :
			card=Card.new()
			card.get_values(numCardsDisplayed)
			card.position = SLOTPOSITIONS[numCardsOnPage]
			card.disabled = false
			pages[maxPages-1].cards.append(card)
			pages[maxPages-1].add_child(card)
			numCardsOnPage+=1
			numCardsDisplayed+=1
	pages[currentPage].visible = true
	
