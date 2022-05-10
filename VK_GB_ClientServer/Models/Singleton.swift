//
//  Singleton.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 16.02.2022.
//

import Foundation

final class Singleton {
    
    public var token: String = ""
    public var userID: Int = 0
    
    public static let instance = Singleton()
    
    private init() { }
}
