//: A UIKit based Playground for presenting user interface
  
import PlaygroundSupport


let game = GameState([
    "😍",
    "👏",
    "🧠",
    "🤞",
    "👨🏻‍💻"])

let viewController = ConcentrationViewController()
viewController.currentGameState = game

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = viewController
