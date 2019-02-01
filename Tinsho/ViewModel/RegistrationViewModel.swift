//
//  RegistrationViewModel.swift
//  Tinsho
//
//  Created by Sherif Kamal on 1/25/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    var fullName: String? {
        didSet { checkFormValidity() }
    }
    
    var email: String? {
        didSet { checkFormValidity() }
    }
    
    var password: String? {
        didSet { checkFormValidity() }
    }
    
    fileprivate func checkFormValidity() {
        let isValidForm = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isValidForm
    }
    
    func performRegistration(completion: @escaping(Error?) -> ()) {
        guard let email = email, let password = password else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let err = err {
                print(err)
                completion(err)
                return
            }
            self.bindableIsRegistering.value = true
            self.saveImageToFirebase(completion: completion)
            
        }
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping(Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName" : fullName ?? "", "uid" : uid, "imageUrl1" : imageUrl]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping(Error?) -> ()) {
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            if let error = err {
                completion(error)
                return
            }
            ref.downloadURL(completion: { (url, err) in
                if let error = err {
                    completion(error)
                    return
                }
                self.bindableIsRegistering.value = false
                completion(nil)
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
        })
    }
}
