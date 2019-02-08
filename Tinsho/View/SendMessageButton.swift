//
//  SendMessageButton.swift
//  Tinsho
//
//  Created by Sherif Kamal on 2/7/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupGradientLayer(rect: rect)
    }
    
    fileprivate func setupGradientLayer(rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 1, green: 0.01176470588, blue: 0.4470588235, alpha: 1)
        let rightColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}
