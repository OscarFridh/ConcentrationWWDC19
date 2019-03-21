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
    
    private func flipAndUpdateView(for card: Card) {
        
        guard let shuffledIndex = shuffledCards.lastIndex(of: card) else {
            return
        }
        
        let indexPath = IndexPath(row: shuffledIndex, section: 0)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCell else {
            return
        }
        
        if currentGameState.state(for: card).isSelected {
            cell.transitionTo(character: card.content, options: .transitionFlipFromTop)
        } else {
            cell.transitionTo(character: "?", options: .transitionFlipFromBottom)
        }
    }
    
    private func matchCard(_ card: Card) {
        
        guard let shuffledIndex = shuffledCards.lastIndex(of: card) else {
            return
        }
        
        let indexPath = IndexPath(row: shuffledIndex, section: 0)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? MyCell else {
            return
        }
        
        UIView.animate(withDuration: 1, delay: 2, options: [], animations: {
            cell.alpha = 0
        }, completion: nil)
    }
    
    lazy private var shuffledCards: [Card] = Array(currentGameState.cards).shuffled()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Set up collectionView and add it to the view hierarchy
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyCell.self.self, forCellWithReuseIdentifier: "cell")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        let card = shuffledCards[indexPath.row]
        configureCell(cell, forCard: card)
        return cell
    }
    
    private func configureCell(_ cell: MyCell, forCard card: Card) {
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

class MyCell: UICollectionViewCell {

    var character: Character? {
        get {
            return label.text?.first
        } set {
            if let newValue = newValue {
                label.text = String(newValue)
            } else {
                label.text = nil
            }
        }
    }
    
    func transitionTo(character: Character, options: UIView.AnimationOptions = .transitionFlipFromTop) {
        UIView.transition(with: self, duration: 0.5, options: options,
                          animations: {
                            self.character = character
        }, completion: nil)
    }

    private var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    private func setUp() {

        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = frame.width/4

        // Important that the view retained and fully set up here! Otherwise it won't show up in the playground.
        label = createLabel()

        contentView.addSubview(label)
        setupConstraints()
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.text = "?"
        label.font = UIFont.systemFont(ofSize: frame.width*0.6)
        label.textAlignment = .center
        return label
    }

    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented or needed in this example")
    }
}
