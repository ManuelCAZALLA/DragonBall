//
//  ApiProvider.swift
//  DragonBall
//
//  Created by Manuel Cazalla Colmenero on 11/10/23.
//

import Foundation

extension NotificationCenter {
    static let apiLoginNotification = Notification.Name ("Notification Api")
    static let apiToken = Notification.Name("Key_Token")
}

protocol ApiProviderProtocol {
    func Login(for user: String, with password: String)
}

class ApiProvider: ApiProviderProtocol {
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"
    
    private enum EndPoint {
        static let login = "/auth/login"
    }
    // MARK:
    func Login(for user: String, with password: String) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(EndPoint.login)") else{
            return
        }
        
        guard let loginData = String(
            format: "%@:%@",
            user, password).data(using: String.Encoding.utf8)?.base64EncodedString() else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)",
                            forHTTPHeaderField: "Authorization")
        // Aqui llamamos a la api
        URLSession.shared.dataTask(with: urlRequest) {  data, response, error in
            guard error == nil else {
                //TODO: Enviar notificacion indicando el error
                return
            }
            
            guard let data ,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                // TODO: Enviar notificacion indicando response error
                return
            }
            
            guard let responseData = String(data: data, encoding: .utf8) else {
                // TODO: Enviar notificacion indicando response vacio
                return
            }
            
            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: [NotificationCenter.apiToken: responseData])
            
          
        }.resume()
    }
}
