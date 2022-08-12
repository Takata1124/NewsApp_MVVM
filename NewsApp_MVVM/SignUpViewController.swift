//
//  SignUpViewController.swift
//  NewsApp_MVVM
//
//  Created by t032fj on 2022/08/12.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var LoginScreenButton: UIButton!
    
    private let signUpViewModel = SignUpViewModel(model: SignUpModel())
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind()
    }
    
    private func setupLayout() {
        
        idTextField.layer.borderColor = UIColor.black.cgColor
        idTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.borderWidth = 0.5
    }
    
    func bind() {
        
        idTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: signUpViewModel.idTextPublishSubject)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: signUpViewModel.passwordTextPublishSubject)
            .disposed(by: disposeBag)
        
        signUpViewModel
            .isValid()
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signUpViewModel
            .isValid()
            .map{ $0 ? 1 : 0.5 }
            .bind(to: signUpButton.rx.alpha)
            .disposed(by: disposeBag)
        
        signUpViewModel.errorValue
            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @IBAction func goUserView(_ sender: Any) {
        performSegue(withIdentifier: "goMakeUser", sender: nil)
    }
    
    @IBAction func goLoginView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
