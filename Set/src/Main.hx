package;

import flash.events.Event;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import openfl.events.MouseEvent;

import openfl.Lib;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import motion.Actuate;

class Main extends Sprite 
{	
	//	Creating the deck array to store the cards which we draw
	var deck:Array<Card>;
	
	// Creating the selection array where we store the selected cards
	var selection:Array<Card> = new Array<Card>();
	
	//	This variable keeps track of how many colums we have created
	var columns:Int = 0;
	
	//	The variables for our buttons
	var dealButtonData:BitmapData = Assets.getBitmapData( "img/deal.png" );
	var endButtonData:BitmapData = Assets.getBitmapData( "img/end.png" );
	var startButtonData:BitmapData = Assets.getBitmapData( "img/new.png" );
	
	// Creating our start button and menu screens
	var startButton:Button;
	var screen:Sprite = new Sprite();
	var endScreen:Sprite = new Sprite();
	
	//	Setting the common text format and creating all the text fields we can use
	var textFormat:TextFormat = new TextFormat("Verdana", 24, 0xff0000, true);
	var titleTextFormat:TextFormat = new TextFormat("Tahoma", 72, 0x006400, true);
	var symbolTextField = new TextField();
	var colorTextField = new TextField();
	var shadingTextField = new TextField();
	var numberTextField = new TextField();
	var cardsLeftTextField = new TextField();
	var cardsInDeckTextField = new TextField();
	var mainMenuTextField = new TextField();
	var endGameTextField = new TextField();
	
	public function new() 
	{
		super();
		
		//	Aligning the common text format
		textFormat.align = TextFormatAlign.CENTER;
		titleTextFormat.align = TextFormatAlign.CENTER;
		
		//	Setting up the main menu
		screen.graphics.beginFill(0x3498db);
		screen.graphics.drawRect(0, 0, 1024, 576);
		
		addChild(screen);
		
		//	Adding the start button for the main menu
		startButton  = new Button(startButtonData);
		startButton.scaleX = startButton.scaleY = .3;
		startButton.x = 512 - (startButton.width/2);
		startButton.y = 288 - (startButton.height/2);
		startButton.addEventListener(MouseEvent.CLICK, onStartButtonClicked);
		
		addChild(startButton);
		
		//	Adding the welcome text
		addChild(mainMenuTextField);
		
		mainMenuTextField.width = 500;
		mainMenuTextField.height = 85;
		mainMenuTextField.y = 100;
		mainMenuTextField.x = screen.width/2 - mainMenuTextField.width/2;
		mainMenuTextField.background = true;
		mainMenuTextField.border = true;
		mainMenuTextField.defaultTextFormat = titleTextFormat;
		mainMenuTextField.selectable = false;
		mainMenuTextField.text = ("Welcome to Set");
		
	}
	
	function newGame()
	{
		//	First, creating a deck
		createDeck();
		
		//	Shuffling the created deck
		shuffleDeck();
		
		// Positioning the cards correctly
		positionCards();
		
		//	Setting up the button to deal cards
		var dealButton:Button = new Button(dealButtonData);
		dealButton.scaleX = dealButton.scaleY = .3;
		dealButton.x = 100;
		dealButton.y = 480;
		dealButton.addEventListener( MouseEvent.CLICK, onDealButtonClicked );
		
		addChild(dealButton);
		
		//	Setting up the button to end the game
		var endButton:Button = new Button(endButtonData);
		endButton.scaleX = endButton.scaleY = .3;
		endButton.x = dealButton.x + dealButton.width + 20;
		endButton.y = 480;
		endButton.addEventListener( MouseEvent.CLICK, onEndButtonClicked );
		
		addChild(endButton);
	}
	
	private function onStartButtonClicked(e:Event):Void
	{
		// When starting the game we remove the main menu objects
		removeChildren();
		
		//	Starting a new game
		newGame();
	}
	
	private function onNewGameButtonClicked(e:Event):Void
	{
		//	When clicking the button for a new game on the end screen we need to remove everything on the screen
		removeChildren();
		
		//	And then start a new game
		newGame();
	}
	
	function positionCards() 
	{
		//	Running a double loop for the columns and rows, placing a card in the inner loop with the loop variables and adding the event listeners to each card
		
		for ( row in 0...3 ) 
		{
			for ( column in 0...4) 
			{
				//	Taking the top card from the deck
				var card:Card = deck.pop();
				
				//	Putting the card on its respective place and rescaling it
				card.scaleX = card.scaleY = .4;
				card.x = 150 + column * 100;
				card.y = 100  + row * 150;
				
				//	Adding the required event listeners for left and right clicking a card
				card.addEventListener( MouseEvent.CLICK, onCardClicked );
				card.addEventListener( MouseEvent.RIGHT_CLICK, onCardRightClicked );
				
				//	We need to track how many columns we have for adding more later
				columns = column; 
			}
		}
		//	Adding another count to the column counter, so the first one we add with the row button doesn't overlap
		columns++;
	}
	
	private function onEndButtonClicked(e:MouseEvent):Void
	{
		//	We don't want to end the game if there's still enough cards in the deck
		if (deck.length < 3)
		{
			//	Setting up the end screen
			endScreen.graphics.beginFill(0xFA8072);
			endScreen.graphics.drawRect(0, 0, 1024, 576);
			
			addChild(endScreen);
			
			//	Adding the button to end the game and start a new one
			startButton  = new Button(startButtonData);
			startButton.scaleX = startButton.scaleY = .3;
			startButton.x = 512 - (startButton.width/2);
			startButton.y = 288 - (startButton.height/2);
			startButton.addEventListener(MouseEvent.CLICK, onNewGameButtonClicked);
			
			addChild(startButton);
			
			//	Adding the game over text
			addChild(endGameTextField);
			
			endGameTextField.width = 500;
			endGameTextField.height = 85;
			endGameTextField.y = 100;
			endGameTextField.x = endScreen.width/2 - endGameTextField.width/2;
			endGameTextField.background = true;
			endGameTextField.border = true;
			endGameTextField.defaultTextFormat = titleTextFormat;
			endGameTextField.selectable = false;
			endGameTextField.text = ("Game Over");
		}
		else
		{
			//	If there are still cards in the deck we display a message saying how many cards there are
			addChild(cardsInDeckTextField);
			
			cardsInDeckTextField.width = 250;
			cardsInDeckTextField.height = 30;
			cardsInDeckTextField.y = 40*6;
			cardsInDeckTextField.x = 195;
			cardsInDeckTextField.background = true;
			cardsInDeckTextField.border = true;
			cardsInDeckTextField.defaultTextFormat = textFormat;
			cardsInDeckTextField.selectable = false;
			cardsInDeckTextField.text = ("Deck still has " + deck.length + " cards");
		}
	}
	
	private function onDealButtonClicked(e:MouseEvent):Void
	{
		//	This is the function for dealing a new row of cards if the players agree.
		//	Only activates if there's enough cards in the deck and there aren't more than 8, so it doesn't go off screen
		if ( deck.length >= 3 && columns < 8 )
		{
			for ( row in 0...3)
			{
				//	Take the card from the deck
				var card:Card = deck.pop();
				
				//	Put the card in its place
				card.scaleX = card.scaleY = .4;
				card.x = 150 + columns * 100;
				card.y = 100  + row * 150;
				
				//	Give it the event listeners
				card.addEventListener( MouseEvent.CLICK, onCardClicked );
				card.addEventListener( MouseEvent.RIGHT_CLICK, onCardRightClicked );
			}
			
			//	This tracks how many columns we've already made, so we know where to place the next one
			columns++;
		}
	}
	
	private function onCardRightClicked(e:MouseEvent):Void 
	{
		//	If someone would want to remove the messages by right clicking, I give them the choice
		removeErrorMessages();
		
		//	Getting a reference to the clicked card
		var card:Card = cast e.target; 
		
		//	Scaling it down to indicate deselection
		card.scaleX = card.scaleY = .4;
		
		//	Removing the card from the selection array
		selection.remove(card);
	}
	
	private function onCardClicked(e:Event):Void 
	{
		//These are to remove any messages from a previous failed set
		removeErrorMessages();
		
		// Getting a reference to the clicked card
		var card:Card = cast e.target;
		
		// Making the cards just a little bigger, so you know you've selected one
		card.scaleX = card.scaleY = .45;
		
		// Adding the selected card to the array of selected cards
		if( selection.indexOf(card) == -1 )
		{
			selection.push( card );
		}
		
		// When we have selected 3 cards, we do this
		if ( selection.length == 3 )
		{
			/*
			 * These booleans contain the various states the selection can be in, namely same attributes and different attributes
			 * With various combinations of theirs, we can check for every possible situation and detect whether we have a set and if not, why
			*/
			var sameSymbol:Bool = selection[0].symbol == selection[1].symbol && selection[0].symbol == selection[2].symbol && selection[1].symbol == selection[2].symbol;
			var sameColor:Bool = selection[0].color == selection[1].color && selection[0].color == selection[2].color && selection[1].color == selection[2].color;
			var sameShading:Bool = selection[0].shading == selection[1].shading && selection[0].shading == selection[2].shading && selection[1].shading == selection[2].shading;
			var sameNumber:Bool = selection[0].number == selection[1].number && selection[0].number == selection[2].number && selection[1].number == selection[2].number;
			
			var differentSymbol:Bool = selection[0].symbol != selection[1].symbol && selection[0].symbol != selection[2].symbol && selection[1].symbol != selection[2].symbol;
			var differentColor:Bool = selection[0].color != selection[1].color && selection[0].color != selection[2].color && selection[1].color != selection[2].color;
			var differentShading:Bool = selection[0].shading != selection[1].shading && selection[0].shading != selection[2].shading && selection[1].shading != selection[2].shading;
			var differentNumber:Bool = selection[0].number != selection[1].number && selection[0].number != selection[2].number && selection[1].number != selection[2].number;
			
			// Here we check if we have any attribute all the same or all different. This is the whole logic of set
			if ((sameSymbol || differentSymbol) && (sameColor || differentColor) && (sameShading || differentShading) && (sameNumber || differentNumber))
			//if (true)
			{
				// If this executes, then we have a set, so we replace the old cards with new ones
				replaceCards();
			} 
			// If we do not have a set
			else
			{
				// This for loop just makes each card in the selection array its original size
				for (card in selection)
				{
					card.scaleX = card.scaleY = .4;
				}
				
				// Of course, if we do not have a set we need to explain why. This function does just that.
				errorMessages(sameSymbol, sameColor, sameShading, sameNumber, differentSymbol, differentColor, differentShading, differentNumber);
			}
			
			// In the end, we clear the selection array, so we can fill it up again later
			selection = new Array<Card>();
		}
		
	}
	
	function removeErrorMessages()
	{
		removeChild(symbolTextField);
		removeChild(colorTextField);
		removeChild(shadingTextField);
		removeChild(numberTextField);
		removeChild(cardsLeftTextField);
		removeChild(cardsInDeckTextField);
	}
	
	// This function checks why a set isn't a set
	private function errorMessages(sameSymbol:Bool, sameColor:Bool, sameShading:Bool, sameNumber:Bool, differentSymbol:Bool, differentColor:Bool, differentShading:Bool, differentNumber:Bool)
	{
		// If an attribute is both not all the same and both not all different then it's incomplete, which is exactly what we're looking for
		// The code within the if statements just adds a text field with the appropriate message. It also possitions them one under the other, so they don't overlap
		if (!sameSymbol && !differentSymbol)
		{			
			addChild(symbolTextField);
			symbolTextField.width = 210;
			symbolTextField.height = 30;
			symbolTextField.x = 195;
			symbolTextField.y = 40;
			symbolTextField.background = true;
			symbolTextField.border = true;
			symbolTextField.defaultTextFormat = textFormat;
			symbolTextField.selectable = false;
			symbolTextField.text = ("Wrong symbols");
		}
		if (!sameColor && !differentColor)
		{
			trace("Wrong colors");
			
			addChild(colorTextField);
			colorTextField.width = 210;
			colorTextField.height = 30;
			colorTextField.y = 40*2;
			colorTextField.x = 195;
			colorTextField.background = true;
			colorTextField.border = true;
			colorTextField.defaultTextFormat = textFormat;
			colorTextField.selectable = false;
			colorTextField.text = ("Wrong colors");
		}
		if (!sameShading && !differentShading)
		{
			trace("Wrong shading");
			
			addChild(shadingTextField);
			shadingTextField.width = 210;
			shadingTextField.height = 30;
			shadingTextField.y = 40*3;
			shadingTextField.x = 195;
			shadingTextField.background = true;
			shadingTextField.border = true;
			shadingTextField.defaultTextFormat = textFormat;
			shadingTextField.selectable = false;
			shadingTextField.text = ("Wrong shading");
		}
		if (!sameNumber && !differentNumber)
		{
			trace("Wrong number");
			
			addChild(numberTextField);
			numberTextField.width = 210;
			numberTextField.height = 30;
			numberTextField.y = 40*4;
			numberTextField.x = 195;
			numberTextField.background = true;
			numberTextField.border = true;
			numberTextField.defaultTextFormat = textFormat;
			numberTextField.selectable = false;
			numberTextField.text = ("Wrong number");
		}
	}
	
	function replaceCards()
	{
		//	This runs for every card in the selection array, since we need to remove it and deal another in its place
		for (selectedCard in selection) 
		{
			//	The set has been made, so we have to remove the old cards
			removeChild( selectedCard );
			
			//	If we try to deal out a card and the deck is empty, the game crashes
			if (deck.length >= 3)
			{
				//	We draw a new card, scale it properly, add some fancy effects and place it on the grid
				var nextCard:Card = deck.pop();
				nextCard.scaleX = nextCard.scaleY = .4;
				Actuate.tween(nextCard, .5, {rotation: 180, x: selectedCard.x, y: selectedCard.y} );
				addChild( nextCard );
				
				nextCard.addEventListener( MouseEvent.CLICK, onCardClicked );
			}
			else
			{
				//	If there are no cards left in the deck, we display an appropriate message
				addChild(cardsLeftTextField);
				
				cardsLeftTextField.width = 210;
				cardsLeftTextField.height = 30;
				cardsLeftTextField.y = 40*5;
				cardsLeftTextField.x = 195;
				cardsLeftTextField.background = true;
				cardsLeftTextField.border = true;
				cardsLeftTextField.defaultTextFormat = textFormat;
				cardsLeftTextField.selectable = false;
				cardsLeftTextField.text = ("No cards left in deck");
			}
		}
	}
	
	function createDeck() 
	{
		//	Creating the deck array of cards
		deck = new Array<Card>();
		
		//	Storing all the possible attributes a card could have
		var colors:Array<String> = ["red", "green", "blue"];
		var symbols:Array<String> = ["diamond", "pill", "wave"];
		var shades:Array<String> = ["shaded", "open", "filled"];
		
		//	Quadruple loop monstrosity to go through every possible attribute for a card
		for (number in 1...4)
		{
			for (color in colors)
			{
				for ( shade in shades)
				{
					for (symbol in symbols) 
					{
						//	Create a card and fill it with the required attributes
						var card:Card = new Card(symbol, number, color, shade);
						
						//	Put it in the deck
						deck.push( card );
						card.x = -200; // This fixes a weird glitch with ghost cards. It's the actual deck, but serves no visual purpose, so I move it out of the way.
						addChild( card );
					}
				}
			}
		}
	}
	
	function shuffleDeck()
	{
		//	Shuffling the deck by running through its length and replacing random cards with other random cards
		var n:Int = deck.length;
		
		for (i in 0...n )
		{
			var change:Int = i + Math.floor( Math.random() * (n -i) );
			var tempCard = deck[i];
			deck[i] = deck[change];
			deck[change] = tempCard;
		}
	}
}