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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = cell.frame.width/4
        return cell
    }
}


class MyCell: UICollectionViewCell {
    
    private var testView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        // Important that the view retained and fully set up here! Otherwise it won't show up in the playground.
        
        testView = UIView()
        testView.backgroundColor = .magenta
        
        contentView.addSubview(testView)
        
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        testView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        testView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        testView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented or needed in this example")
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
