//
//  LoginViewModel.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewModel {
  
  var bindableIsFormValid = Bindable<Bool>()
  var bindableIsLoggingIn = Bindable<Bool>()
  
  var email: String? { didSet { checkFormIsValid() } }
  var password: String? { didSet { checkFormIsValid() } }
  
  fileprivate func checkFormIsValid() {
    let isFormValid = email?.isEmpty == false && password?.isEmpty == false
    bindableIsFormValid.value = isFormValid
  }
  
  func performLogin(completion: @escaping (Error?) -> ()) {
    guard let email = email else { return }
    guard let password = password else { return }
    bindableIsLoggingIn.value = true
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      if let error = error {
        completion(error)
        return
      }
      
      print("successfully logged in")
      completion(nil)
    }
  }
}
