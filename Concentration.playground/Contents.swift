//: A UIKit based Playground for presenting user interface
  
import PlaygroundSupport


let viewController = ConcentrationViewController()
viewController.cards = [
    "好",
    "你",
    "很",
    "我",
    "她"
]
viewController.voice = Voice(language: .chinese)

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = viewController
