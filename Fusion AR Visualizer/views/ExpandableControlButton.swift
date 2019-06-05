//
//  ExpandableControlRow.swift
//  Fusion AR Visualizer
//
//  Created by Theo Chemel on 6/1/19.
//  Copyright © 2019 Theo Chemel. All rights reserved.
//

import Foundation
import UIKit

class ExpandableControlButton: UIView {
    
    var backgroundViewWidthConstraint: NSLayoutConstraint!
    
    var isExpanded = false
    
    var slider: UISlider!
    
    init(icon: UIImage?, sliderMin: Float, sliderMax: Float) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        
        let backgroundView: UIView = {
//            let view = UIView()
//            view.backgroundColor = .controlButton
//            view.layer.cornerRadius = 28.0
//            view.translatesAutoresizingMaskIntoConstraints = false
//            return view
            let blurVisualEffect = UIBlurEffect(style: .dark)
            let visualEffectView = UIVisualEffectView(effect: blurVisualEffect)
            visualEffectView.layer.cornerRadius = 28.0
            visualEffectView.layer.masksToBounds = true
            visualEffectView.translatesAutoresizingMaskIntoConstraints = false
            return visualEffectView
        }()
        addSubview(backgroundView)
        
        backgroundViewWidthConstraint = backgroundView.widthAnchor.constraint(equalToConstant: 56.0)
        
        NSLayoutConstraint.activate([
            backgroundViewWidthConstraint,
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        slider = {
            let slider = UISlider()
            slider.minimumValue = sliderMin
            slider.maximumValue = sliderMax
            slider.tintColor = .white
            slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.4)
            slider.alpha = 0.0
            slider.translatesAutoresizingMaskIntoConstraints = false
            return slider
        }()
        addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0),
            slider.widthAnchor.constraint(equalToConstant: 212.0),
            slider.heightAnchor.constraint(equalToConstant: 18.0),
            slider.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        let button = ControlButton(icon: icon)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 56.0),
            button.heightAnchor.constraint(equalToConstant: 56.0),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    @objc func buttonTapped(_ sender: ControlButton) {
        if isExpanded {
            isExpanded = false
            
            UIView.animate(withDuration: 0.2) {
                self.backgroundViewWidthConstraint.constant = 56.0
                self.slider.alpha = 0.0
                self.layoutIfNeeded()
            }
            
        } else {
            isExpanded = true
            
            UIView.animate(withDuration: 0.2) {
                self.backgroundViewWidthConstraint.constant = 300.0
                self.slider.alpha = 1.0
                self.layoutIfNeeded()
            }
        }
    }
    
}
