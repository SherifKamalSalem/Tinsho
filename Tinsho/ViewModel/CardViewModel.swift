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
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = self.imageNames[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    //Reactive programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
