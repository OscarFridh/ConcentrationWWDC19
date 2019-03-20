//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

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

extension MyViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        let card = game.cards[indexPath.row]
        if card.isSelected {
            cell.character = card.content
        } else if card.hasBeenMatched {
            cell.character = "✅"
        } else {
            cell.character = "?"
        }

        return cell
    }
}

extension MyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        game.select(game.cards[indexPath.row])
        collectionView.reloadData()
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
