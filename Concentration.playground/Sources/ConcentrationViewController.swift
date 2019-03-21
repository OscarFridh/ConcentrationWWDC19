//: A UIKit based Playground for presenting user interface
  
import UIKit

public class ConcentrationViewController : UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 60, height: 60)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.09803921569, blue: 0.1843137255, alpha: 1)
        return collectionView
    }()

    // Dependency injection
    public var currentGameState: GameState!
    
    lazy private var shuffledCards: [Card] = Array(currentGameState.cards).shuffled()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Set up collectionView and add it to the view hierarchy
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)

        // Pin collectionView to view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        
        if cardState.hasBeenMatched {
            cell.character = "✅"
        } else if cardState.isSelected {
            cell.character = card.content
        } else {
            cell.character = "?"
        }
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
        
        if currentGameState.selectedCards.count == 1 {
            // 2.a. Hide previous selection and show the new card
            for card in oldGameState.selectedCards {
                flipAndUpdateView(for: card)
            }
            flipAndUpdateView(for: card)
        } else if currentGameState.state(for: card).hasBeenMatched {
            // 2.b Show the new card and animation for correct answer
            flipAndUpdateView(for: card)
            print("TODO: Correct answer animation")
        } else {
            // 2.c Show the new card and animation for wrong answer
            flipAndUpdateView(for: card)
            print("TODO: Wrong answer animation")
        }
    }
}

// MARK: Animations

extension ConcentrationViewController {
    
    private func flipAndUpdateView(for card: Card) {
        
        guard let cell = cellForCard(card) else {
            return
        }
        
        let newCharacter: Character
        let transition: UIView.AnimationOptions
        
        if currentGameState.state(for: card).isSelected {
            newCharacter = card.content
            transition = .transitionFlipFromTop
        } else {
            newCharacter = "?"
            transition = .transitionFlipFromBottom
        }
        
        UIView.transition(with: cell, duration: 0.5, options: transition,
                          animations: {
                            cell.character = newCharacter
        }, completion: nil)
    }
    
    private func cellForCard(_ card: Card) -> CardCell? {
        guard let shuffledIndex = shuffledCards.lastIndex(of: card) else {
            return nil
        }
        
        let indexPath = IndexPath(row: shuffledIndex, section: 0)
        return collectionView.cellForItem(at: indexPath) as? CardCell
    }
    
    private func matchCard(_ card: Card) {
        
        guard let cell = cellForCard(card) else {
            return
        }
        
        UIView.animate(withDuration: 1, delay: 2, options: [], animations: {
            cell.alpha = 0
        }, completion: nil)
    }
}
