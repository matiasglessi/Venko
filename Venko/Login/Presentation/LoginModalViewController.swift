//
//  LoginModalViewController.swift
//  Venko
//
//  Created by Matias Glessi on 25/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit

class LoginModalViewController: UIViewController {

    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet var backgroundView: UIView!
    var loginAction: ((String) -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAlertUI()
        closeButton.round()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateIn()
    }
    
    private func animateIn() {
        self.modalView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.4) {
            self.modalView.alpha = 1
            self.modalView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func login(_ sender: Any) {
        guard let dni = dniTextField.text else { return }
        if dni.isEmpty { return }
        
        self.dismiss(animated: true, completion: nil)
        loginAction?(dni)
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func configureAlertUI() {
        modalView.round(to: 15)
        modalView.alpha = 0
        modalView.setBorder(width: 1.5, color: UIColor.white.cgColor)
    }
}
