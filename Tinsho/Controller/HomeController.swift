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

class HomeController: UIViewController, SettingsControllerDelegate, RegisterAndLoginDelegate, CardViewDelegate {

    var user: User?
    var cardViewModels = [CardViewModel]()
    
    let topStackView = TopNavigationStackView()
    let bottomControls = HomeBottomControlsStackView()
    let cardDeckView = UIView()
    var lastFetchUser: User?
    var topCardView: CardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingButton.addTarget(self, action: #selector(handleSettingBtnPressed), for: .touchUpInside)
        bottomControls.refreshBtn.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeBtn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
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
        
        let minAge = user?.minSeekingAge ?? 18
        let maxAge = user?.maxSeekingAge ?? 50
        
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
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCard(fromUser: user)
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
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
    
    @objc func handleLike() {
        if topCardView != nil {
            topCardView?.removeFromSuperview()
        }
    }
    
    fileprivate func setupCard(fromUser user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true)
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
}
