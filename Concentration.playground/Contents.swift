//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class ConcentrationGame {
    
    let cards: [Card]
    
    init(_ content: Set<Character>) {
        var array = [Card]()
        array += content.map { Card(content: $0) }
        array += content.map { Card(content: $0) }
        cards = array.shuffled()
    }
    
    func select(_ card: Card) {
        
        // Deselect last match/mismatch
        if selectedCards.count == 2 {
            selectedCards.forEach { $0.isSelected = false }
        }
        
        // Select the new card
        card.isSelected = true
        
        // Mark matches
        if hasSelectedTwoMatchingCards {
            selectedCards.forEach { $0.hasBeenMatched = true }
        }
    }
    
    private var hasSelectedTwoMatchingCards: Bool {
        return selectedCards.count == 2 && Set(selectedCards.map { $0.content }).count == 1
    }
    
    private var selectedCards: [Card] {
        return cards.filter { $0.isSelected }
    }
    
}


class Card {
    
    let content: Character
    fileprivate(set) var isSelected: Bool
    fileprivate(set) var hasBeenMatched: Bool
    
    init(content: Character) {
        self.content = content
        self.isSelected = false
        self.hasBeenMatched = false
    }
    
}


class MyViewController : UIViewController {
    
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
    
    let game = ConcentrationGame([
        "😍",
        "👏",
        "🧠",
        "🤞",
        "👨🏻‍💻"
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up collectionView and add it to the view hierarchy
        collectionView.dataSource = self
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

extension MyViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        cell.character = game.cards[indexPath.row].content
        return cell
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

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
