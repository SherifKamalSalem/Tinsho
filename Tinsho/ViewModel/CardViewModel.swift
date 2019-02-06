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
    let uid: String
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    var imageIndexObserver: ((Int, String?) -> ())?
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = self.imageUrls[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    init(uid: String, imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.uid = uid
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
