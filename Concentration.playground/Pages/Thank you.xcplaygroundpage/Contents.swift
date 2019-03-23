/*:
 [Previous](@previous)
 # Thank you!
 I really appreaciate that you took the time to look at my Playground. Here's one last game of concentration before I say goodbye.
 */

import PlaygroundSupport

let viewController = ConcentrationViewController()
viewController.cards = [
    "👨🏻‍💻",
    "🎒",
    "🏄‍♂️",
    "🏊‍♂️",
    "✈️",
    "🎉"
]
viewController.voice = Voice(language: .english)

PlaygroundPage.current.liveView = viewController

//: ![Playground icon](profile_small.png)

/*:
 Bye for now. Hope to see you at **#WWDC2019**!
 */

/*:
 - callout(Extra): If you're interested you can check out all the commits of this playground on [Github](https://www.solarsystemscope.com/textures)
 */
