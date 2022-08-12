//
//  SignUpViewModel.swift
//  NewsApp_MVVM
//
//  Created by t032fj on 2022/08/12.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    
    let errorValue: Observable<String>
    let idTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    init(model: SignUpModelProtocol) {
        let event = Observable
            .combineLatest(idTextPublishSubject.asObservable().startWith(""), passwordTextPublishSubject.asObservable())
            .skip(1)
            .flatMap { idText, passwordText -> Observable<Event<Void>> in
                return model
                    .validate(idText: idText, passwordText: passwordText)
                    .materialize()
            }
            .share()
        
        self.errorValue = event
            .flatMap { event -> Observable<String> in
                switch event {
                case .next:
                    return .just("OK!")
                case let .error(error as ModelError):
                    return .just(error.errorText)
                case .error, .completed:
                    return .empty()
                }
            }
            .startWith("ID と Password を入力してください。")
    }
    
    func isValid() -> Observable<Bool> {
        return Observable
            .combineLatest(idTextPublishSubject.asObservable().startWith(""), passwordTextPublishSubject.asObservable())
            .map { id, password in
                return id.count > 3 && password.count > 3
            }
            .startWith(false)
    }
}
