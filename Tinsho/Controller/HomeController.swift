//
//  ViewController.swift
//  Tinsho
//
//  Created by Sherif Kamal on 1/19/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit
import Firebase
import ARSLineProgress

class HomeController: UIViewController, SettingsControllerDelegate, RegisterAndLoginDelegate {

    var user: User?
    var cardViewModels = [CardViewModel]()
    
    let topStackView = TopNavigationStackView()
    let bottomControls = HomeBottomControlsStackView()
    let cardDeckView = UIView()
    var lastFetchUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingButton.addTarget(self, action: #selector(handleSettingBtnPressed), for: .touchUpInside)
        bottomControls.refreshBtn.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        fetchCurrentUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser?.uid == nil {
            let loginController = LoginController()
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
            present(navController, animated: true, completion: nil)
        }
    }
    
    func userLoggedIn() {
        fetchCurrentUserData()
    }
    
    fileprivate func fetchCurrentUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.fetchUsersFromFirestore()
            ARSLineProgress.hide()
        }
    }
    
    fileprivate func fetchUsersFromFirestore() {
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }
        ARSLineProgress.show()
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot, err) in
            ARSLineProgress.hide()
            if let err = err {
                print(err) 
                return
            }
            
            if snapshot?.count == 0 {
                ARSLineProgress.hide()
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                ARSLineProgress.hide()
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchUser = user
                self.setupCard(fromUser: user)
            })
        }
    }
    
    @objc func handleSettingBtnPressed() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true, completion: nil)
    }
    
    func didSaveSettings() {
        fetchCurrentUserData()
    }
    
    @objc func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    fileprivate func setupCard(fromUser user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    //MARK: - Fileprivate
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardDeckView)
    }
    
//    // setup the animation of card
//    fileprivate func setupFirestoreUserCards() {
//        cardViewModels.forEach { (cardViewModel) in
//            let cardView = CardView(frame: .zero)
//            cardView.cardViewModel = cardViewModel
//            cardDeckView.addSubview(cardView)
//            cardDeckView.fillSuperview()
//        }
//    }
}
