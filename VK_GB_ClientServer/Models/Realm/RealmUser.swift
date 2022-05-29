//
//  RealmUser.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 26.02.2022.
//

import Foundation
import RealmSwift

class UserRealm: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var photo: String = ""
    @Persisted var sex = Int()
    @Persisted var fullName: String = ""
}

extension UserRealm {
    convenience init(user: User) {
        self.init()
        
        self.id = user.id
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.photo = user.photo
        self.sex = user.sex
        self.fullName = user.fullName
    }
}

extension UserRealm: Comparable {
    public static func < (lhs: UserRealm, rhs: UserRealm) -> Bool {
        lhs.lastName < rhs.lastName
    }
}
