//
//  SignUpModel.swift
//  NewsApp_MVVM
//
//  Created by t032fj on 2022/08/12.
//

import Foundation
import RxSwift

protocol SignUpModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Observable<Void>
}

final class SignUpModel: SignUpModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Observable<Void> {
        switch (idText, passwordText) {
        case (.none, .none):
            return Observable.error(ModelError.invalidIdAndPassword)
        case (.none, .some):
            return Observable.error(ModelError.invalidId)
        case (.some, .none):
            return Observable.error(ModelError.invalidPassword)
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                return Observable.error(ModelError.invalidIdAndPassword)
            case (false, false):
                if idText.count  < 4 {
                    return Observable.error(ModelError.idtooShot)
                }
                if passwordText.count  < 4 {
                    return Observable.error(ModelError.passwordtooShot)
                }
                return Observable.just(())
            case (true, false):
                return Observable.error(ModelError.invalidId)
            case (false, true):
                return Observable.error(ModelError.invalidPassword)
            }
        }
    }
}
