//
//  LoginController.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import ARSLineProgress

protocol RegisterAndLoginDelegate {
    func userLoggedIn()
}

class LoginController: UIViewController {
    
    var loginViewModel = LoginViewModel()
    var delegate: RegisterAndLoginDelegate?
    let gradientLayer = CAGradientLayer()
    
    let emailTxtField : CustomTxtField = {
        let tf = CustomTxtField(padding: 24)
        tf.placeholder = "Enter email"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    let passwordTxtField : CustomTxtField = {
        let tf = CustomTxtField(padding: 24)
        tf.placeholder = "Enter password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(handleLoginBtnPressed), for: .touchUpInside)
        button.layer.cornerRadius = 22
        return button
    }()
    
    fileprivate let backToRegisterButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBackBtnPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var verticalStackView : UIStackView = {
        let vs = UIStackView(arrangedSubviews: [
            emailTxtField,
            passwordTxtField,
            loginButton
            ])
        vs.axis = .vertical
        vs.spacing = 8
        return vs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupGestures()
        setupSubviewTargets()
        setupLoginViewModelBindables()
    }
    
    fileprivate func setupLayout() {
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupGestures() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    fileprivate func setupSubviewTargets() {
        let fields = [emailTxtField, passwordTxtField]
        fields.forEach { $0.addTarget(self, action: #selector(handleTextChange), for: .editingChanged) }
        loginButton.addTarget(self, action: #selector(handleLoginBtnPressed), for: .touchUpInside)
        backToRegisterButton.addTarget(self, action: #selector(handleBackBtnPressed), for: .touchUpInside)
    }
    
    fileprivate func setupLoginViewModelBindables() {
        loginViewModel.bindableIsFormValid.bind { [weak self] (isFormValid) in
            guard let self = self else { return }
            guard let isFormValid = isFormValid else { return }
            
            self.loginButton.isEnabled = isFormValid
            self.loginButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8273344636, green: 0.09256268293, blue: 0.324395299, alpha: 1) : .lightGray
            self.loginButton.setTitleColor(isFormValid ? .white : .darkGray, for: .normal)
        }
        loginViewModel.bindableIsLoggingIn.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                ARSLineProgress.show()
            } else {
                ARSLineProgress.hide()
            }
        }
    }
    
    @objc fileprivate func handleBackBtnPressed() {
        let registrationController = RegistrationViewController()
        present(registrationController, animated: true)
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTxtField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    @objc fileprivate func handleLoginBtnPressed() {
        //handleTapGesture()
        loginButton.isEnabled = false
        let loginHUD = JGProgressHUD(style: .dark)
        loginHUD.textLabel.text = "Attempting to login"
        loginHUD.show(in: view)
        
        loginViewModel.performLogin { [weak self] (error) in
            loginHUD.dismiss()
            guard let self = self else { return }
            
            if let error = error {
                print(error)
                self.showHUDWithError(error)
                self.loginButton.isEnabled = true
                self.loginViewModel.bindableIsLoggingIn.value = false
            }
            
            self.dismiss(animated: true, completion: {
                self.delegate?.userLoggedIn()
            })
        }
    }
    
    @objc fileprivate func handleTapGesture() {
        view.endEditing(true)
    }

    fileprivate func showHUDWithError(_ error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: view)
        hud.dismiss(afterDelay: 2.5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
}
