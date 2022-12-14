//
//  ViewController.swift
//  NewsApp_MVVM
//
//  Created by t032fj on 2022/08/12.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel(model: LoginModel())
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpScreenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        idTextField.layer.borderColor = UIColor.black.cgColor
        idTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.borderWidth = 0.5
        
        bind()
    }
    
    func bind() {
        
        idTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: loginViewModel.idTextPublishSubject)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: loginViewModel.passwordTextPublishSubject)
            .disposed(by: disposeBag)
        
        loginViewModel
            .isValid()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginViewModel
            .isValid()
            .map{ $0 ? 1 : 0.5 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        loginViewModel.errorValue
            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @IBAction func goHomeView(_ sender: Any) {
        performSegue(withIdentifier: "goHome", sender: nil)
    }
  
    @IBAction func goSignUpView(_ sender: Any) {
        performSegue(withIdentifier: "goSignUp", sender: nil)
    }
}

