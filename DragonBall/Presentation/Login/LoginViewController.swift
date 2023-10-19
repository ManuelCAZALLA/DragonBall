//
//  LoginViewController.swift
//  DragonBall
//
//  Created by Manuel Cazalla Colmenero on 10/10/23.
//

import UIKit

// MARK: - View Protocol
protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? {get set }
    var heroesViewModel: HeroesViewControllerDelegate { get }
    func loginTap(email: String?, password: String?)
   
}

enum LoginViewState { // estos son los estados de la vista y se lo paso al viewState del protocolo
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
}

class LoginViewController: UIViewController {
    
    // MARK: -IBOutlet -
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var ViewActivityIndicator: UIView!
    
    // MARK: - IBAction -
    @IBAction func LoginTap(_ sender: Any) {
        // Obtener el email y password introducidos por el usuario y
        //enviarlos a la api
        viewModel?.loginTap(
            email: email.text,
            password: password.text)
        
    }
    // MARK: - Public Properties
    var viewModel: LoginViewControllerDelegate?
    
    // estos eson los tag para textFieldDidEndEditing y para initView
    private enum FieldType: Int {
        case email = 0
        case password // si no le das valor coge el siguiente: 1
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad() // LLamo a las funciones
        initViews()
        setObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "LoginToHeroes",
              let heroesViewController = segue.destination as? HeroesViewController else {
            return
            }
        
        heroesViewController.viewModel = viewModel?.heroesViewModel
    }
    // MARK: - Private Func
    private func initViews() {
        email.delegate = self // aqui detecto cuando el usuario empieza a escribir y oculto los emailError
        email.tag = FieldType.email.rawValue
        password.delegate = self
        password.tag = FieldType.password.rawValue
        
        // Esto detecta cuando le das a la pantalla, y se oculta el teclado
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismisskeyboard)
            )
        )
    }
    
    @objc func dismisskeyboard() { // esta funcion es para el selector
        view.endEditing(true) // Oculta el teclado
    }
    
    private func setObserver() { // le digo a viewModel todas las posibles vistas para que me diga que hago
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state{
                case .loading(let isLoading):
                    self?.ViewActivityIndicator.isHidden = !isLoading
                    
                case .showErrorEmail(let error):
                    self?.emailError.text = error
                    self?.emailError.isHidden = false
                    
                case .showErrorPassword(let error):
                    self?.passwordError.text = error
                    self?.passwordError.isHidden = false
                    
                    
                case .navigateToNext:
                    self?.performSegue(withIdentifier: "LoginToHeroes", sender: nil)
                }
            }
        }
        
    }
}


extension LoginViewController: UITextFieldDelegate { // como el email = self en init view no conforma el protolo hago esta extension
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag) { // aqui decimos que cuando escribimos en estos campos los error se ocultan
            
        case .email:
            emailError.isHidden = true
            
        case .password:
            password.isHidden = true
            
        default: break
        }
    }
}

