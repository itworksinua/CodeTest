//
//  LoginViewController.swift
//  PingPongResult
//
//  Created by Admin on 24.06.2019.
//  Copyright © 2019 itWorksInUA. All rights reserved.
//

import UIKit
import Komponents

class LoginViewController: UIViewController, Component {
    
    var reactEngine: KomponentsEngine?
    
    var state = LoginState()
    
    override func loadView() { loadComponent() }
    
    // MARK - View
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login Screen"
        
        navigationController?.view.endEditingTap()
        
        DataManager.manager.checkUser { [weak self] in
            self?.moveToMain(animated: false)
        }
    }
    
    var emailFieldRef = UITextField() /*{
        didSet {
            DispatchQueue.main.async {
                self.emailFieldRef.delegate = self
            }
        }
    }*/
    var passwordFieldRef = UITextField() /*{
        didSet {
            DispatchQueue.main.async {
                self.passwordFieldRef.delegate = self
            }
        }
    }*/
    var buttonRef = UIButton()
    
    func render() -> Tree {
        return View([
            VerticalStack(props: { $0.spacing = 8 },
                          layout: Layout().fillHorizontally().top(80), [
                            Field("Email",
                                  text: state.email,
                                  textChanged: { [weak self] email in self?.updateState { $0.email = email } } ,
                                  //                      style: emailStyle,
                                layout: Layout().height(40),
                                ref : &emailFieldRef
                            ),
                            Field("Password",
                                  text: state.password,
                                  textChanged: { [weak self] pass in self?.updateState { $0.password = pass } } ,
                                  //                      style: passwordStyle,
                                layout: Layout().height(40),
                                ref : &passwordFieldRef
                            )
                ]),
            VerticalStack(layout: Layout().fillHorizontally().bottom(0), [
                Button(buttonTextForState(state.status),
                       tap: { [weak self] in self?.login() },
                       //                       style: loginButtonStyle,
                    layout: Layout().height(44),
                    ref : &buttonRef
                ),
                Button("SignUp", tap: moveToSignUp, props: { $0.setTitleColor(.blue, for: .normal) }, layout: Layout().height(44))
                ])
            ])
    }
    
    func didRender() {
        applyStyles()
        
        view.endEditingTap()
    }
    
    func didUpdateState() {
        applyStyles()
    }
    
    func applyStyles() {
        emailStyle(f: emailFieldRef)
        passwordStyle(f: passwordFieldRef)
        loginButtonStyle(b: buttonRef)
    }
    
    func login() {
        updateState { $0.status = .loading }
        view.endEditing(true)
        DataManager.manager.auth(userName: state.email, password: state.password) { [weak self] error in
            if let error = error {
                self?.updateState { $0.status = .error }
                let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            } else {
                self?.updateState { $0.status = .success }
                self?.moveToMain()
            }
        }
    }
    
    func moveToSignUp() {
        let main = RegisterViewController()
        navigationController?.pushViewController(main, animated: true)
    }
    
    func moveToMain(animated: Bool = true) {
        let main = ResultsViewController()
        navigationController?.setViewControllers([main], animated: animated)
    }
    
    // MARK - Styles
    
    func inputStyle(_ f: UITextField) {
        f.borderStyle = .roundedRect
        f.font = UIFont(name: "HelveticaNeue-Light", size: 26)
        f.layer.borderWidth = 1
    }
    
    func emailStyle(f: UITextField) {
        inputStyle(f)
        f.autocorrectionType = .no
        f.keyboardType = .emailAddress
        f.autocapitalizationType = .none
        f.returnKeyType = .next
        f.layer.borderColor = state.emailValid == .invalid ? UIColor.red.cgColor : UIColor.green.cgColor
        
        f.delegate = self
    }
    
    func passwordStyle(f: UITextField) {
        inputStyle(f)
        f.isSecureTextEntry = true
        f.returnKeyType = .done
        f.layer.borderColor = state.passwordValid == .invalid ? UIColor.red.cgColor : UIColor.green.cgColor
        
        f.delegate = self
    }
    
    func loginButtonStyle(b: UIButton) {
        let status = state.status
        b.backgroundColor = .lightGray
        b.isEnabled = status == .unknown || status == .error
        b.alpha = (status == .loading) ? 0.5 : 1
        b.backgroundColor = self.buttonColorForState(status)
        b.isEnabled = state.isFormvalid()
    }
    
    // MARK - Helpers
    
    fileprivate func buttonColorForState(_ status: LoginStatus) -> UIColor {
        switch status {
        case .unknown, .loading:
            return .lightGray
        case .success:
            return .green
        case .error:
            return .red
        }
    }
    
    fileprivate func buttonTextForState(_ status: LoginStatus) -> String {
        switch status {
        case .unknown:
            return "Login"
        case .loading:
            return "Login..."
        case .success:
            return "Success"
        case .error:
            return "Error, try login again"
        }
    }
}

struct LoginState {
    var email = "" { didSet { validate() } }
    var password = "" { didSet { validate() } }
    fileprivate var status = LoginStatus.unknown
    fileprivate var emailValid = FieldValidationStatus.unknown
    fileprivate var passwordValid = FieldValidationStatus.unknown
    
    func isFormvalid() -> Bool { return emailValid == .valid && passwordValid == .valid }
    
    private mutating func validate() {
        emailValid = email.contains("@") ? .valid : .invalid
        passwordValid = password.count >= 6 ? .valid : .invalid
        status = .unknown
    }
}
fileprivate enum FieldValidationStatus {
    case unknown
    case valid
    case invalid
}

fileprivate enum LoginStatus {
    case unknown
    case loading
    case success
    case error
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailFieldRef:
            passwordFieldRef.becomeFirstResponder()
        case passwordFieldRef:
            login()
        default:
            break
        }
        return true
    }
}
