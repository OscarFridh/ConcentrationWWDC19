import UIKit

protocol ResultsViewControllerDelegate: class {
    func resultsViewControllerDidFinish(_ viewController: ResultsViewController)
}

public class ResultsViewController: UIViewController {
    
    weak var delegate: ResultsViewControllerDelegate?
    
    // Dependency injection
    public var gameState: GameState!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .wwdcBackground
        
        let test = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 100))
        test.backgroundColor = .red
        view.addSubview(test)
        
        print("You finished in \(gameState.moves) moves")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.resultsViewControllerDidFinish(self)
    }
}
