//
//  CardView.swift
//  Tinsho
//
//  Created by Sherif Kamal on 1/23/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit

class CardView: UIView {

    let gradientLayer = CAGradientLayer()
    var imageIndex = 0
    fileprivate let deselectedColor = UIColor(white: 0, alpha: 0.1)
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            imageView.image = UIImage(named: imageName)
            infoLabel.attributedText = cardViewModel.attributedString
            infoLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).map { (_) in
                let barView = UIView()
                barView.backgroundColor = deselectedColor
                barView.layer.cornerRadius = 3
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
        }
    }
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
    fileprivate let infoLabel = UILabel()
    fileprivate let barsStackView = UIStackView()
    //configration
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChangedState(gesture)
        case .ended:
            handleEndedState(gesture)
        default:
            ()
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto {
            imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1)
        } else {
            imageIndex = max(0, imageIndex - 1)
        }
        
        let imageName = cardViewModel.imageNames[imageIndex]
        imageView.image = UIImage(named: imageName)
        barsStackView.arrangedSubviews.forEach { (v) in
            v.backgroundColor = deselectedColor
        }
        barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        //Add gradient layer
        setupGradientLayer()
        addSubview(infoLabel)
        
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        infoLabel.textColor = .white
        infoLabel.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        infoLabel.numberOfLines = 0
        
        imageView.fillSuperview()
        setupBarsStackView()
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    fileprivate func handleEndedState(_ gesture: UIPanGestureRecognizer) {
        
        let transationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 600 * transationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    //rotate the card view by angle of 20 to make this animation
    fileprivate func handleChangedState(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        //rotation transformation
        let degree: CGFloat = translation.x / 20
        let angle = degree * .pi / 180
        
        let rotationTranformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTranformation.translatedBy(x: translation.x, y: translation.y)
    }
}