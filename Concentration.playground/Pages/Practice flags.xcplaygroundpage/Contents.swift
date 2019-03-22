
/*:
 [Previous](@previous)
 # Practice flags
 Let's practice some flags of people we might run in to at WWDC!
  */

import PlaygroundSupport

let viewController = ConcentrationViewController()
viewController.cards = [
    "🇧🇬",
    "🇩🇪",
    "🇬🇷",
    "🇮🇳",
    "🇮🇹",
    "🇲🇾",
    "🇵🇱",
    "🇪🇸",
    "🇧🇷",
    "🇨🇦",
    "🇦🇺",
    "🇨🇳",
    "🇸🇪",
    "🇺🇸"
]

PlaygroundPage.current.liveView = viewController
viewController.voice = Voice(language: .english)

/*:
 - Experiment: Practice even more flags! For example: 🇳🇴, 🇩🇰 and 🇫🇮. You can also change the voice with a different language accent or turn off the sound if you like.
 */

//: [Next](@next)
