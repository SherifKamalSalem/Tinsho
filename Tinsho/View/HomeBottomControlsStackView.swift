//
//  HomeBottomControlsStackView.swift
//  Tinsho
//
//  Created by Sherif Kamal on 1/23/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    let refreshBtn = createButton(withImage: #imageLiteral(resourceName: "refresh_circle"))
    let dislikeBtn = createButton(withImage: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeBtn = createButton(withImage: #imageLiteral(resourceName: "super_like_circle"))
    let likeBtn = createButton(withImage: #imageLiteral(resourceName: "like_circle"))
    let specialBtn = createButton(withImage: #imageLiteral(resourceName: "boost_circle"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        [refreshBtn, dislikeBtn, superLikeBtn, likeBtn, specialBtn].forEach { (button) in
            self.addArrangedSubview(button)
        }
    }
    
    static func createButton(withImage image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
