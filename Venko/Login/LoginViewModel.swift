//
//  LoginViewModel.swift
//  Venko
//
//  Created by Matias Glessi on 05/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoginViewModel {
    
    let login: Login
    
    init(login: Login) {
        self.login = login
    }

    func login(with dni: String = APIConstants().TEST_LOGIN, completionHandler: @escaping ([Routine], Bool) -> Void){
        login.login(with: dni, completionHandler: completionHandler)
    }
}


protocol Login {
    func login(with dni: String, completionHandler: @escaping ([Routine], Bool) -> Void)
}

class APILogin: Login {

    func login(with dni: String, completionHandler: @escaping ([Routine], Bool) -> Void){
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
