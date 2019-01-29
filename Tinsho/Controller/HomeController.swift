//
//  ViewController.swift
//  Tinsho
//
//  Created by Sherif Kamal on 1/19/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    var cardViewModels = [CardViewModel]()
    
    let topStackView = TopNavigationStackView()
    let buttonsStackView = HomeBottomControlsStackView()
    let cardDeckView = UIView()
    var lastFetchUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingButton.addTarget(self, action: #selector(handleSettingBtnPressed), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        fetchUserFromFirestore()
    }
    
    fileprivate func fetchUserFromFirestore() {
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print(err) 
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchUser = user
            })
            self.setupFirestoreUserCards()
        }
    }
    
    @objc func handleSettingBtnPressed() {
        let registrationViewController = RegistrationViewController()
        present(registrationViewController, animated: true, completion: nil)
        
    }
    
    //MARK: - Fileprivate
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardDeckView)
    }
    
    // setup the animation of card
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}
