import UIKit

public class ConcentrationViewController : UIViewController {
    
    // Dependency injection
    public var cards: Set<Character>! {
        didSet {
            restartGame()
        }
    }
    
    public var voice: Voice?

    private var currentGameState: GameState!
    private var shuffledCards: [Card]!
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .wwdcBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 60, height: 60)
        return layout
    }()

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Pin collectionView to view
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func restartGame() {
        currentGameState = GameState(cards)
        shuffledCards = Array(currentGameState.cards).shuffled()
        collectionView.reloadData()
    }
    
    private func showResults() {
        let resultsViewController = ResultsViewController()
        resultsViewController.delegate = self
        resultsViewController.gameState = currentGameState
        present(resultsViewController, animated: true, completion: nil)
    }
}

extension ConcentrationViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuffledCards.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCell
        let card = shuffledCards[indexPath.row]
        configureCell(cell, forCard: card)
        return cell
    }
    
    private func configureCell(_ cell: CardCell, forCard card: Card) {
        let cardState = currentGameState.state(for: card)
        cell.contentView.alpha = cardState.hasBeenMatched ? 0 : 1
        cell.character = cardState.isSelected ? card.content : "?"
    }
}

extension ConcentrationViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = shuffledCards[indexPath.row]
        let cardState = currentGameState.state(for: card)
        
        guard !cardState.hasBeenMatched && !cardState.isSelected else {
            return
        }
        let oldGameState = currentGameState!
        
        // 1. Update the model
        currentGameState = currentGameState.selecting(card)
        let capturedGameState = currentGameState! // Capture the current game state for later use in animations
        
        if currentGameState.selectedCards.count == 1 {
            
            // 2.a. Hide previous selection and show the new card
            if !oldGameState.selectedCards.intersection(oldGameState.matchedCards).isEmpty {
                // The last selection was a match so we don't need to flip those cards here
                flipCard(card, faceUp: true)
            } else {
                flipCards(oldGameState.selectedCards, faceUp: false) {
                    self.flipCard(card, faceUp: true)
                }
            }
            
        } else if currentGameState.state(for: card).hasBeenMatched {
            
            // 2.b Show the new card and animation for correct answer
            flipCard(card, faceUp: true) { _ in
                self.animateMatch(for: capturedGameState.selectedCards)
                // Check if game over
                if capturedGameState.isFinished {
                    self.showResults()
                }
            }
            
        } else {
            
            // 2.c Show the new card and animation for wrong answer
            flipCard(card, faceUp: true)
            // TODO: Animation for wrong answer
        }
        
        // Speak the card!
        voice?.speak("\(card.content)")
    }
}

extension ConcentrationViewController: ResultsViewControllerDelegate {
    func resultsViewControllerDidFinish(_ viewController: ResultsViewController) {
        restartGame()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Animations

extension ConcentrationViewController {
    
    private func flipCards(_ cards: Set<Card>, faceUp: Bool, completion: (() -> ())? = nil) {
        
        let group = DispatchGroup()
        
        for card in cards {
            group.enter()
            flipCard(card, faceUp: faceUp) { _ in
                group.leave()
            }
        }
        
        if let completion = completion {
            group.notify(queue: .main, work: DispatchWorkItem(block: completion))
        }
    }
    
    private func flipCard(_ card: Card, faceUp: Bool, completion: ((Bool) -> ())? = nil) {
        
        guard let cell = cellForCard(card) else {
            // IMPORTANT: We still need to refresh the cell and call the completion handler!
            collectionView.reloadItems(at: [indexPathForCard(card)])
            completion?(false)
            return
        }
        
        let newCharacter: Character
        let transition: UIView.AnimationOptions
        
        if faceUp {
            newCharacter = card.content
            transition = .transitionFlipFromTop
        } else {
            newCharacter = "?"
            transition = .transitionFlipFromBottom
        }
        
        UIView.transition(with: cell, duration: 0.5, options: transition,
                          animations: {
                            cell.character = newCharacter
        }, completion: completion)
    }
    
    private func indexPathForCard(_ card: Card) -> IndexPath {
        return IndexPath(row: shuffledCards.lastIndex(of: card)!, section: 0)
    }
    
    
    private func cellForCard(_ card: Card) -> CardCell? {
        guard let shuffledIndex = shuffledCards.lastIndex(of: card) else {
            return nil
        }
        
        let indexPath = IndexPath(row: shuffledIndex, section: 0)
        return collectionView.cellForItem(at: indexPath) as? CardCell
    }
    
    
    private func animateMatch(for cards: Set<Card>) {
        UIView.animate(withDuration: 0.5, animations: {
            for card in cards {
                if let cell = self.cellForCard(card) {
                    cell.contentView.alpha = 0
                }
            }
        })
    }
}
