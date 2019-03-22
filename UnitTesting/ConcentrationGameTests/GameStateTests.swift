//
//  GameStateTests.swift
//  ConcentrationGameTests
//
//  Created by Oscar Fridh on 2019-03-20.
//  Copyright © 2019 Oscar Fridh. All rights reserved.
//

import XCTest
@testable import ConcentrationGame

class GameStateTests: XCTestCase {


    // MARK: Test init
    
    func testInitCardCount() {
        XCTAssertEqual(GameState(["A", "B", "C"]).cards.count, 6, "There should be twice as many cards as the input")
        XCTAssertEqual(GameState(["A"]).cards.count, 2, "There should be twice as many cards as the input")
    }
    
    func testInitCardContent() {
        let game = GameState(["A", "B", "C"])
        let content = Set(game.cards.map { $0.content })
        XCTAssertEqual(content, ["A", "B", "C"])
    }
    
    func testInitCardFileterDublicates() {
        XCTAssertEqual(GameState(["A", "A", "A"]).cards.count, 2, "Dublicates should be removed and there should be twice as many cards as the filtered input")
    }
    
    
    // MARK: Test playing the game
    
    func testInitialCardState() {
        let initialState = GameState(["A", "B", "C"])
        for card in initialState.cards {
            let state = initialState.state(for: card)
            XCTAssertFalse(state.isSelected, "A card should not be selected initially")
            XCTAssertFalse(state.hasBeenMatched, "A card should not be matched initially")
        }
    }
    
    func testSelectFirstCard() {
        let initialState = GameState(["A", "B", "C"])
        let card = (initialState.cards.filter { $0.content == "A" })[0]
        
        let nextState = initialState.selecting(card)
        
        XCTAssert(nextState.state(for: card).isSelected, "The card should be selected after the select function has been called")
    }
    
    func testSelectMatch() {
        let initialState = GameState(["A"])
        let cards = Array(initialState.cards)
        let card1 = cards[0]
        let card2 = cards[1]
        
        let intermediateState = initialState.selecting(card1)
        XCTAssertEqual(intermediateState.state(for: card1), CardState(isSelected: true, hasBeenMatched: false))
        XCTAssertEqual(intermediateState.state(for: card2), CardState(isSelected: false, hasBeenMatched: false))
        
        let finalState = intermediateState.selecting(card2)
        XCTAssertEqual(finalState.state(for: card1), CardState(isSelected: true, hasBeenMatched: true))
        XCTAssertEqual(finalState.state(for: card2), CardState(isSelected: true, hasBeenMatched: true))
    }
    
    func testSelectMismatch() {
        let initialState = GameState(["A", "B"])
        let card1 = (initialState.cards.filter { $0.content == "A" })[0]
        let card2 = (initialState.cards.filter { $0.content == "B" })[0]
        
        let intermediateState = initialState.selecting(card1)
        XCTAssertEqual(intermediateState.state(for: card1), CardState(isSelected: true, hasBeenMatched: false))
        XCTAssertEqual(intermediateState.state(for: card2), CardState(isSelected: false, hasBeenMatched: false))
        
        let finalState = intermediateState.selecting(card2)
        XCTAssertEqual(finalState.state(for: card1), CardState(isSelected: true, hasBeenMatched: false))
        XCTAssertEqual(finalState.state(for: card2), CardState(isSelected: true, hasBeenMatched: false))
    }
    
    func testSelectAfterMatch() {
        let initialState = GameState(["A", "B"])
        let firstCards = Array(initialState.cards.filter { $0.content == "A" })
        let card1 = firstCards[0]
        let card2 = firstCards[1]
        let card3 = (initialState.cards.filter { $0.content == "B" })[0]
        let stateAfterMatch = initialState.selecting(card1).selecting(card2)
        
        let stateToTest = stateAfterMatch.selecting(card3)
        
        XCTAssertEqual(stateToTest.state(for: card1), CardState(isSelected: false, hasBeenMatched: true))
        XCTAssertEqual(stateToTest.state(for: card2), CardState(isSelected: false, hasBeenMatched: true))
        XCTAssertEqual(stateToTest.state(for: card3), CardState(isSelected: true, hasBeenMatched: false))
    }
    
    func testSelectAfterMismatch() {
        let initialState = GameState(["A", "B", "C"])
        let card1 = (initialState.cards.filter { $0.content == "A" })[0]
        let card2 = (initialState.cards.filter { $0.content == "B" })[0]
        let card3 = (initialState.cards.filter { $0.content == "C" })[0]
        let stateAfterMismatch = initialState.selecting(card1).selecting(card2)
        
        let stateToTest = stateAfterMismatch.selecting(card3)
        
        XCTAssertEqual(stateToTest.state(for: card1), CardState(isSelected: false, hasBeenMatched: false))
        XCTAssertEqual(stateToTest.state(for: card2), CardState(isSelected: false, hasBeenMatched: false))
        XCTAssertEqual(stateToTest.state(for: card3), CardState(isSelected: true, hasBeenMatched: false))
    }
    
    
    func testIsFinished() {
        let initialState = GameState(["A"])
        let cards = Array(initialState.cards)
        let card1 = cards[0]
        let card2 = cards[1]
        
        XCTAssertFalse(initialState.isFinished)
        
        let intermediateState = initialState.selecting(card1)
        XCTAssertFalse(intermediateState.isFinished)
        
        let finalState = intermediateState.selecting(card2)
        XCTAssert(finalState.isFinished)
    }
    
}
