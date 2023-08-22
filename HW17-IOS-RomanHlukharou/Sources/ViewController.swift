import UIKit
import SnapKit

class ViewController: UIViewController {
    var newPassword = ""
    let queue = OperationQueue()
    var isStopped: Bool = false
    var bruteOperation = FirstOperation(passwordToUnlock: "")
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change bg color", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        textField.textColor = .cyan
        textField.layer.cornerRadius = 15
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .cyan
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 15
        button.setTitle("Start/Stop", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        return indicator
    }()
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupHierarchy() {
        view.addSubview(button)
        view.addSubview(textField)
        view.addSubview(label)
        view.addSubview(startButton)
        view.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        
        button.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(50)
            make.bottom.equalTo(view.snp.bottom).offset(-200)
            make.height.equalTo(44)
            make.right.equalTo(view.snp.right).offset(-50)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(50)
            make.top.equalTo(view.snp.top).offset(200)
            make.height.equalTo(44)
            make.right.equalTo(view.snp.right).offset(-50)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(60)
            make.left.equalTo(view.snp.left).offset(50)
            make.height.equalTo(25)
            make.right.equalTo(view.snp.right).offset(-50)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(50)
            make.left.equalTo(view.snp.left).offset(50)
            make.height.equalTo(44)
            make.right.equalTo(view.snp.right).offset(-50)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(15)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(25)
        }
    }
    
    @objc func buttonTapped() {
        isBlack.toggle()
    }

    func checkPassword(_ text: String) -> Bool {
        return text.containsValidCharacter
    }

    func alert(with newPassword: String) {
        let alert = UIAlertController(title: "\(newPassword) - incorrect",
                                      message: "INPUT ONLY: \(String().printable)",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK",
                                     style: .destructive,
                                     handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true,
                completion: { self.textField.text = "" })
    }
    
    func startHacking() {
        guard !bruteOperation.isExecuting else {
            bruteOperation.cancel()
            return }
        
        newPassword = textField.text ?? ""
        guard checkPassword(newPassword) else {
            alert(with: newPassword)
            return
        }
        bruteOperation = FirstOperation(passwordToUnlock: newPassword)
        bruteOperation.delegate = self
        queue.addOperation(bruteOperation)
        activityIndicator.startAnimating()
    }
    
    @objc func startButtonTapped() {
        startHacking()
        
        }
    }
    
extension ViewController: ShowPasswordProtocol {

    func showPasswordLabel(_ password: String) {
        label.text = password
    }

    func successHacking() {
        activityIndicator.stopAnimating()
        textField.isSecureTextEntry = false
        label.text = bruteOperation.passwordToUnlock
    }

    func cancelHacking() {
        activityIndicator.stopAnimating()
        label.text = "password is not hacked"
    }
}
