//
//  User.swift
//  Tinsho
//
//  Created by Sherif Kamal on 1/24/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit

struct User: CardViewModelDelegate {
    let uid: String?
    let name: String?
    let age: Int?
    let profession: String?
    let imageUrl1: String?
    
    init(dictionary: [String : Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        "Jobless"
        self.uid = dictionary["uid"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        let professionString = profession != nil ? "\(profession!)" : "Not Available"
        attributedText.append(NSMutableAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        attributedText.append(NSMutableAttributedString(string: "  \n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}
