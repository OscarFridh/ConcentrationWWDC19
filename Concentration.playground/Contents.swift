//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
//    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
//        let collectionView = UIView()
        collectionView.backgroundColor = .red
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
//        print(collectionView.frame)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
