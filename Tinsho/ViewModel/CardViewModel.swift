//
//  CardViewModel.swift
//  Tinsho
//
//  Created by Sherif Kamal on 1/24/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit

protocol CardViewModelDelegate {
    func toCardViewModel() -> CardViewModel 
}

class CardViewModel {
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    var imageIndex = 0
    
    func advanceToNextPhoto() {
        imageIndex = imageIndex + 1
    }
    
    func advanceToPreviousPhoto() {
        imageIndex = imageIndex - 1
    }
}
