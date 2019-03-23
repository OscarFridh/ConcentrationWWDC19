/*:
 [Previous](@previous)
 # Chinese characters
 I've started studying chinese this semester and I will have my first exam later this week. Let's practice some of the characters that I need to learn! It's much more fun in a Playground! 加油！
 */

import PlaygroundSupport

let viewController = ConcentrationViewController()
viewController.cards = Cards.ChineseGlossaries.chapter1 // (out of 7)
viewController.voice = Voice(language: .chinese)

PlaygroundPage.current.liveView = viewController

/*:
 - callout(Tip): Better with 🔊
 */

//: [Next](@next)
