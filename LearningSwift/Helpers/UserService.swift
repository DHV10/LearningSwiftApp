//
//  UserService.swift
//  LearningSwift
//
//  Created by DHV on 30/06/2021.
//

import Foundation

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
}
