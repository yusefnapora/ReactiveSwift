//
//  DummySignInService.swift
//  ReactiveSwift
//
//  Created by Yusef Napora on 6/11/14.
//  Copyright (c) 2014 Yusef Napora. All rights reserved.
//

import Foundation

class DummySignInService {
    func signIn(username: String, password: String, complete: (Bool) -> Void) {
        let success = (username == "username" && password == "password")
        complete(success)
    }
}