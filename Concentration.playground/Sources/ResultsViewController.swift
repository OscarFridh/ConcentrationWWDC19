import UIKit

protocol ResultsViewControllerDelegate: class {
    func resultsViewControllerDidFinish(_ viewController: ResultsViewController)
}

public class ResultsViewController: UIViewController {
    
    weak var delegate: ResultsViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .wwdcBackground
        
        let test = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 100))
        test.backgroundColor = .red
        view.addSubview(test)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.resultsViewControllerDidFinish(self)
    }
}
