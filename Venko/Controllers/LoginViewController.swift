//
//  LoginViewController.swift
//  Venko
//
//  Created by Matias Glessi on 18/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dniTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    @IBAction func login(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginModalViewController") as! LoginModalViewController
        controller.loginAction = { dni in
            self.login(with: dni)
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func testUserLogin(_ sender: Any) {
        
        loginToServer(for: "10") { (routines, error) in
            if !error {
                self.goToRoutinesScreen(with: routines, and: "10")
            }
        }
    }
    
    
    private func login(with dni: String) {
        loginToServer(for: dni) { (routines, error) in
            if error {
                self.showAlert(for: dni)
            }
            else {
                self.goToRoutinesScreen(with: routines, and: dni)
            }
        }
    }
    
    private func showAlert(for dni: String) {
        let alertController = UIAlertController(title: "Error", message: "El DNI \(dni) no existe.", preferredStyle: .alert)
        let defaultAction = UIAlertAction.init(title: "Aceptar", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    private func goToRoutinesScreen(with routines: [Routine], and dni: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RoutinesViewController") as! RoutinesViewController
        controller.routines = routines
        controller.dni = dni
        self.present(controller, animated: true, completion: nil)

    }
    
    private func loginToServer(for dni: String, completionHandler: @escaping ([Routine], Bool) -> Void){
        Alamofire.request(APIConstants().BASE_URL  + APIConstants().LOGIN + dni).responseJSON { response in
            
            if let value = response.result.value {
                let jsonItems = JSON(value)
                
                var items = [Routine]()
                
                for jsonRoutine in jsonItems["items"].arrayValue {
                    if let routine = Routine.init(json: jsonRoutine) {
                        items.append(routine)
                    }
                }
                completionHandler(items, false)
            }
            else {
                completionHandler([], true)
            }
        }
    }
}

