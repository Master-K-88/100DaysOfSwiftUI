//
//  GetTokenViewModel.swift
//  My
//
//  Created by Prof K on 6/29/22.
//

import Foundation
class GetTokenViewModel {
    let api: JamitAPIProtocol = JamitAPI()
    let endpont = NewJamitApiEndpoint.METHOD_GET_CSRF
    
    func getCSRFToken() {
        api.getCSRFToken(endpoint: endpont) { result in
            switch result {
            case .success(let data):
                print("I am testing the response from the server \(data.csrfToken)")
                let key = NewSettingManager.KEY_CSRF_TOKEN
                NewSettingManager.saveSetting(key, data.csrfToken)
            case .failure(_):
                debugPrint("I am getting an error")
            }
        }
    }
}
