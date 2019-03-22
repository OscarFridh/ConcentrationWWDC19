//: A UIKit based Playground for presenting user interface
  
import PlaygroundSupport

let viewController = ConcentrationViewController()
viewController.cards = ChineseGlossaries.chapter1
viewController.voice = Voice(language: .chinese)

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = viewController
