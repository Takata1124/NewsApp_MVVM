//
//  LoginModel.swift
//  NewsApp_MVVM
//
//  Created by t032fj on 2022/08/12.
//

import Foundation
import RxSwift

enum ModelError: Error {
    case invalidId
    case invalidPassword
    case invalidIdAndPassword
    case passwordtooShot
    case idtooShot
}

extension ModelError {
    var errorText: String {
        switch self {
        case .invalidIdAndPassword:
            return "IDとPasswordが未入力です。"
        case .invalidId:
            return "IDが未入力です。"
        case .invalidPassword:
            return "Passwordが未入力です。"
        case .idtooShot:
            return "IDは4文字以上で入力してください"
        case .passwordtooShot:
            return "Passwordは4文字以上で入力してください"
        }
    }
}

protocol LoginModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Observable<Void>
}

final class LoginModel: LoginModelProtocol {
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


