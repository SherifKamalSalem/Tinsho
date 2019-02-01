//
//  AgeRangeCell.swift
//  Tinsho
//
//  Created by Sherif Kamal on 2/1/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    class AgeRangLbl : UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    let minSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()

    let maxSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let minLbl : AgeRangLbl = {
        let lbl = AgeRangLbl()
        lbl.text = "Min: 88"
        return lbl
    }()
    
    let maxLbl : AgeRangLbl = {
        let lbl = AgeRangLbl()
        lbl.text = "Max: 88"
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLbl, minSlider]),
            UIStackView(arrangedSubviews: [maxLbl, maxSlider])
            ])
        overallStackView.axis = .vertical
        overallStackView.spacing = 10
        overallStackView.distribution = .fillEqually
        addSubview(overallStackView)
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
