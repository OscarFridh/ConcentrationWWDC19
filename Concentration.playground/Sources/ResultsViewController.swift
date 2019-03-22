import UIKit

protocol ResultsViewControllerDelegate: class {
    func resultsViewControllerDidFinish(_ viewController: ResultsViewController)
}

public class ResultsViewController: UIViewController {
    
    weak var delegate: ResultsViewControllerDelegate?
    
    // Dependency injection
    public var gameState: GameState!
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "🎉Good job🎉"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 50)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "You finished in \(gameState.moves) moves"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .wwdcBackground
        
        setupViewHierarchy()
        setupConstraints()
        
        print("You finished in \(gameState.moves) moves")
    }
    
    private func setupViewHierarchy() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
    }
    
    private func setupConstraints() {
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.resultsViewControllerDidFinish(self)
    }
}
