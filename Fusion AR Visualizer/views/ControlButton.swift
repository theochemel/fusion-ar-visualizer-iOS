//
//  ControlButton.swift
//  Fusion AR Visualizer
//
//  Created by Theo Chemel on 6/1/19.
//  Copyright © 2019 Theo Chemel. All rights reserved.
//

import Foundation
import UIKit

class ControlButton: UIButton {
    
    init(icon: UIImage?) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .controlButton
        
        layer.cornerRadius = 28.0
        layer.masksToBounds = true
        
        setImage(icon, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 12.0, bottom: 14.0, right: 12.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
}
