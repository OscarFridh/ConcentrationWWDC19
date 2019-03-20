//: A UIKit based Playground for presenting user interface
  
import PlaygroundSupport


let game = ConcentrationGame([
    "😍",
    "👏",
    "🧠",
    "🤞",
    "👨🏻‍💻"])

let viewController = ConcentrationViewController()
viewController.game = game

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = viewController
