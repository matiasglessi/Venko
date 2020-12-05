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


