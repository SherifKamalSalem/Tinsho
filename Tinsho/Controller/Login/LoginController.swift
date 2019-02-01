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

protocol RegisterAndLoginDelegate {
  func userLoggedIn()
}

class LoginController: UIViewController {
  
    var loginViewModel = LoginViewModel()
    var delegate: RegisterAndLoginDelegate?
    
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

    lazy var verticalStackView : UIStackView = {
        let vs = UIStackView(arrangedSubviews: [
            emailTxtField,
            passwordTxtField
            ])
        vs.axis = .vertical
        vs.distribution = .fillEqually
        vs.spacing = 8
        return vs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupLayout()
        setupGestures()
        setupSubviewTargets()
        setupLoginViewModelBindables()
    }

//    fileprivate func setupLayout() {
//        view.addSubview(loginView)
//        loginView.fillSuperview()
//        navigationController?.isNavigationBarHidden = true
//    }

    fileprivate func setupGestures() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }

    fileprivate func setupSubviewTargets() {
        let fields = [emailTxtField, passwordTxtField]
        fields.forEach { $0.addTarget(self, action: #selector(handleTextChange), for: .editingChanged) }
        loginButton.addTarget(self, action: #selector(handleLoginBtnPressed), for: .touchUpInside)
        //goToRegistrationButton.addTarget(self, action: #selector(handleGoToRegistrationTapped), for: .touchUpInside)
    }

    fileprivate func setupLoginViewModelBindables() {
        loginViewModel.bindableIsFormValid.bind { [weak self] (isFormValid) in
          guard let self = self else { return }
          guard let isFormValid = isFormValid else { return }
          
          self.loginButton.isEnabled = isFormValid
          if isFormValid {
            self.loginButton.backgroundColor = #colorLiteral(red: 0.8273344636, green: 0.09256268293, blue: 0.324395299, alpha: 1)
            self.loginButton.setTitleColor(.white, for: .normal)
          } else {
            self.loginButton.backgroundColor = .gray
            self.loginButton.setTitleColor(.darkGray, for: .normal)
          }
        }
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

  @objc fileprivate func handleGoToRegistrationTapped() {
    navigationController?.popViewController(animated: true)
  }

  fileprivate func showHUDWithError(_ error: Error) {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Failed Registration"
    hud.detailTextLabel.text = error.localizedDescription
    hud.show(in: view)
    hud.dismiss(afterDelay: 2.5)
  }
  
}
