/*:
 # Concentration
 [Concentration](https://en.wikipedia.org/wiki/Concentration) also known as Match Match, Match Up, Memory, Pelmanism, Shinkei-suijaku, Pexeso or simply Pairs, is a card game in which all of the cards are laid face down on a surface and two cards are flipped face up over each turn. The object of the game is to turn over pairs of matching cards.
 
 In this playground the cards will take on faces of Apple's rich emojis and characters.
 */


/*:
 - callout(The API): In order to play a game of concentration we simply create and configure a ConcentrationViewController.
 */

import PlaygroundSupport

// 1. Create and configure a ConcentrationViewController
let viewController = ConcentrationViewController()
viewController.cards = [
    "😍",
    "👏",
    "🧠",
    "🤞",
    "👨🏻‍💻"
]

// Optionally add a voice to read the cards as they are being flipped face up
viewController.voice = Voice(language: .english)

// 2. Add the view controller as the liveView
PlaygroundPage.current.liveView = viewController




/*:
 In the following pages I have prepared some more games using this API.
 
 [Continue](@next)
 */
