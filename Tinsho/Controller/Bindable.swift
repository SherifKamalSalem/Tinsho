//
//  Bindable.swift
//  Tinsho
//
//  Created by Sherif Kamal on 1/28/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
