
/*:
 [Previous](@previous)
 # Practice flags
 Let's practice some flags of people we might run into at WWDC!
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
viewController.voice = Voice(language: .english)

PlaygroundPage.current.liveView = viewController

/*:
 - Experiment: Practice even more flags! For example: 🇳🇴, 🇩🇰 and 🇫🇮. You can also change the voice with a different language accent or turn off the sound if you like.
 */

//: [Next](@next)
