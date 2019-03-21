//: A UIKit based Playground for presenting user interface
  
import PlaygroundSupport


let viewController = ConcentrationViewController()
viewController.cards = [
    "😍",
    "👏",
    "🧠",
    "🤞",
    "👨🏻‍💻"
]

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = viewController
