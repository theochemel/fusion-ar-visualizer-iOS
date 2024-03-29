//
//  ControlView.swift
//  Fusion AR Visualizer
//
//  Created by Theo Chemel on 5/31/19.
//  Copyright © 2019 Theo Chemel. All rights reserved.
//

// <div>Icons made by <a href="https://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
//<div>Icons made by <a href="https://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
//<div>Icons made by <a href="https://www.flaticon.com/authors/good-ware" title="Good Ware">Good Ware</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
//<div>Icons made by <a href="https://www.flaticon.com/authors/iconnice" title="Iconnice">Iconnice</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
import Foundation
import UIKit

class ControlViewController: UIViewController {
    
    var delegate: ARControlsDelegate?
    
    var connectionStatusBackgroundBlurView: UIVisualEffectView!
    var connectionStatusBackgroundBlurViewWidthConstraint: NSLayoutConstraint!
    var connectionStatusIndicator: UIView!
    var connectionStatusLabel: UILabel!
    
    var connectionAddressBackgroundBlurView: UIVisualEffectView!
    var connectionAddressTextField: UITextField!
    var connectionAddressConnectButton: UIButton!
    
    var scaleExpandableButton = ExpandableControlButton(icon: UIImage(named: "scale"), sliderMin: 10.0, sliderMax: 80.0)
    var rotateExpandableButton = ExpandableControlButton(icon: UIImage(named: "rotate"), sliderMin: 0.0, sliderMax: Float.pi * 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        connectionStatusBackgroundBlurView = {
            let effect = UIBlurEffect(style: .dark)
            let effectView = UIVisualEffectView(effect: effect)
            effectView.translatesAutoresizingMaskIntoConstraints = false
            effectView.layer.cornerRadius = 16.0
            effectView.layer.masksToBounds = true
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapConnectionIndicator(_:)))
            effectView.addGestureRecognizer(tapGestureRecognizer)
            
            return effectView
        }()
        view.addSubview(connectionStatusBackgroundBlurView)
        
        connectionStatusBackgroundBlurViewWidthConstraint = connectionStatusBackgroundBlurView.widthAnchor.constraint(equalToConstant: 160.0)

        
        NSLayoutConstraint.activate([
            connectionStatusBackgroundBlurViewWidthConstraint,
            connectionStatusBackgroundBlurView.heightAnchor.constraint(equalToConstant: 32.0),
            connectionStatusBackgroundBlurView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            connectionStatusBackgroundBlurView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
        ])
        
        connectionStatusIndicator = {
            let view = UIView()
            view.backgroundColor = .red
            view.layer.cornerRadius = 5.0
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        connectionStatusBackgroundBlurView.contentView.addSubview(connectionStatusIndicator)
        
        NSLayoutConstraint.activate([
            connectionStatusIndicator.heightAnchor.constraint(equalToConstant: 10.0),
            connectionStatusIndicator.widthAnchor.constraint(equalToConstant: 10.0),
            connectionStatusIndicator.centerYAnchor.constraint(equalTo: connectionStatusBackgroundBlurView.centerYAnchor),
            connectionStatusIndicator.leftAnchor.constraint(equalTo: connectionStatusBackgroundBlurView.leftAnchor, constant: 16.0),
        ])
        
        connectionStatusLabel = {
            let label = UILabel()
            label.text = "Not Connected"
            label.font = UIFont.systemFont(ofSize: 14.0)
            label.textAlignment = .left
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        connectionStatusBackgroundBlurView.contentView.addSubview(connectionStatusLabel)
        
        NSLayoutConstraint.activate([
            connectionStatusLabel.heightAnchor.constraint(equalToConstant: 20.0),
            connectionStatusLabel.leadingAnchor.constraint(equalTo: connectionStatusIndicator.trailingAnchor, constant: 10.0),
            connectionStatusLabel.trailingAnchor.constraint(equalTo: connectionStatusBackgroundBlurView.trailingAnchor, constant: -16.0),
            connectionStatusLabel.centerYAnchor.constraint(equalTo: connectionStatusBackgroundBlurView.centerYAnchor),
        ])
        
        connectionAddressBackgroundBlurView = {
            let blurEffect = UIBlurEffect(style: .dark)
            let effectView = UIVisualEffectView(effect: blurEffect)
            effectView.translatesAutoresizingMaskIntoConstraints = false
            effectView.layer.cornerRadius = 16.0
            effectView.layer.masksToBounds = true
            effectView.alpha = 0.0
            return effectView
        }()
        view.addSubview(connectionAddressBackgroundBlurView)
        
        NSLayoutConstraint.activate([
            connectionAddressBackgroundBlurView.heightAnchor.constraint(equalToConstant: 48.0),
            connectionAddressBackgroundBlurView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            connectionAddressBackgroundBlurView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            connectionAddressBackgroundBlurView.topAnchor.constraint(equalTo: connectionStatusBackgroundBlurView.bottomAnchor, constant: 16.0),
        ])
        
        connectionAddressConnectButton = {
            let button = UIButton()
            button.backgroundColor = .clear
            button.setImage(UIImage(named: "connect"), for: .normal)
            button.tintColor = .white
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(didTapConnect(_:)), for: .touchUpInside)
            return button
        }()
        connectionAddressBackgroundBlurView.contentView.addSubview(connectionAddressConnectButton)
        
        NSLayoutConstraint.activate([
            connectionAddressConnectButton.widthAnchor.constraint(equalToConstant: 24.0),
            connectionAddressConnectButton.heightAnchor.constraint(equalToConstant: 24.0),
            connectionAddressConnectButton.trailingAnchor.constraint(equalTo: connectionAddressBackgroundBlurView.contentView.trailingAnchor, constant: -16.0),
            connectionAddressConnectButton.centerYAnchor.constraint(equalTo: connectionAddressBackgroundBlurView.centerYAnchor),
        ])
        
        connectionAddressTextField = {
            let textField = UITextField()
            textField.placeholder = "ws://localhost:8080/connect"
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.keyboardType = .URL
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.backgroundColor = .clear
            return textField
        }()
        connectionAddressBackgroundBlurView.contentView.addSubview(connectionAddressTextField)
        
        NSLayoutConstraint.activate([
            connectionAddressTextField.heightAnchor.constraint(equalToConstant: 30.0),
            connectionAddressTextField.leadingAnchor.constraint(equalTo: connectionAddressBackgroundBlurView.leadingAnchor, constant: 16.0),
            connectionAddressTextField.trailingAnchor.constraint(equalTo: connectionAddressConnectButton.leadingAnchor, constant: -16.0),
            connectionAddressTextField.centerYAnchor.constraint(equalTo: connectionAddressBackgroundBlurView.centerYAnchor),
        ])
        
        view.addSubview(scaleExpandableButton)
        scaleExpandableButton.slider.addTarget(self, action: #selector(didChangeScaleSlider(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            scaleExpandableButton.widthAnchor.constraint(equalToConstant: 300.0),
            scaleExpandableButton.heightAnchor.constraint(equalToConstant: 56.0),
            scaleExpandableButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            scaleExpandableButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
        ])
        
        view.addSubview(rotateExpandableButton)
        rotateExpandableButton.slider.addTarget(self, action: #selector(didChangeRotateSlider(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            rotateExpandableButton.widthAnchor.constraint(equalToConstant: 300.0),
            rotateExpandableButton.heightAnchor.constraint(equalToConstant: 56.0),
            rotateExpandableButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            rotateExpandableButton.bottomAnchor.constraint(equalTo: scaleExpandableButton.topAnchor, constant: -16.0),
        ])
    }
    
    @objc func didTapConnectionIndicator(_ sender: UIView) {
        UIView.animate(withDuration: 0.2) {
            self.connectionAddressBackgroundBlurView.alpha = (self.connectionAddressBackgroundBlurView.alpha == 0.0 ? 1.0 : 0.0)
        }
        view.endEditing(true)
    }
    
    @objc func didTapConnect(_ sender: UIButton) {
        guard let connectionAddress = connectionAddressTextField.text else { return }
        delegate?.shouldChangeConnectionAddress(connectionAddress)
        
        UIView.animate(withDuration: 0.2) {
            self.connectionAddressBackgroundBlurView.alpha = (self.connectionAddressBackgroundBlurView.alpha == 0.0 ? 1.0 : 0.0)
        }
        view.endEditing(true)
    }
    
    @objc func didChangeScaleSlider(_ sender: UISlider) {
        delegate?.shouldChangeModelScale(sender.value)
    }
    
    @objc func didChangeRotateSlider(_ sender: UISlider) {
        delegate?.shouldChangeModelRotation(sender.value)
    }
    
    func setConnectionStatus(isConnected: Bool) {
        connectionStatusIndicator.backgroundColor = (isConnected ? UIColor.green : UIColor.red)
        connectionStatusLabel.text = (isConnected ? "Connected" : "Not Connected")
        connectionStatusBackgroundBlurViewWidthConstraint.constant = (isConnected ? 124.0 : 150.0)
    }
    
}

protocol ARControlsDelegate: class {
    func shouldChangeModelScale(_ value: Float)
    func shouldChangeModelRotation(_ value: Float)
    func shouldChangeConnectionAddress(_ value: String)
}
