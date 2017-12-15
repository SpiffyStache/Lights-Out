 //
//  KataButton.swift
//  Lights Out Kata
//
//  Created by Robbie Cravens on 6/12/17.
//  Copyright © 2017 Robbie Cravens. All rights reserved.
//

import UIKit
class KataButton: UIButton {
    
    var wasSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSelected = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func awakeFromNew() {
        
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.orange : UIColor.white
        }
    }
    
    func toggle() {
        isSelected = !isSelected
    }
    
}
