//
//  ViewModel.swift
//  DragonBall
//
//  Created by Manuel Cazalla Colmenero on 10/10/23.
//

import Foundation


class LoginViewModel: LoginViewControllerDelegate {
    // MARK: Dependencies
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    // MARK: - Properties
    var viewState: ((LoginViewState) -> Void)?
    var heroesViewModel: HeroesViewControllerDelegate {
        HeroesViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }
    
    //MARK: INIT
    init(apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector (onLoginResponse),
            name: NotificationCenter.apiLoginNotification,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func loginTap(email: String?, password: String?) {
         self.viewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Indique un email correcto"))
                return
            }
            
            guard  self.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Indique una contraseña correcta"))
                return
            }
            
            self.doLoginWith(email: email ?? "", password: password ?? "")
        }
    }
    
    @objc func onLoginResponse(_ notification: Notification){
        //TODO: Parsear resultado que vendra en notification.userinfo
        guard let token = notification.userInfo?[NotificationCenter.tokenKey] as? String,
              !token.isEmpty else {
            return
        }
        
        secureDataProvider.save(token: token) // Aqui guardo el token
        viewState?(.loading(false))
        viewState?(.navigateToNext)
    }
    
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && (email?.contains("@") ?? false)
    }
    
    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }
    
    private func doLoginWith(email: String,password: String) {
        
        apiProvider.login(for: email, with: password)
    }
    
}
