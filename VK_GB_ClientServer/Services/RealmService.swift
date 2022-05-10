//
//  RealmService.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 26.02.2022.
//

import RealmSwift

final class RealmService {
    public static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    public class func save<T: Object>(
        items: [T],
        configuration: Realm.Configuration = deleteIfMigration,
        update: Realm.UpdatePolicy = .modified) throws {
            let realm = try Realm(configuration: configuration)
            try realm.write {
                realm.add(
                    items,
                    update: update)
            }
        }
    
    public class func add<T: Object> (item: T) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(item)
        }
    }
    
    public class func load<T: Object> (typeOf: T.Type) throws -> Results<T> {
        let realm = try Realm()
        return realm.objects(T.self)
    }
    
    public class func load<T: Object>(typeOf: T.Type) throws -> [T] {
        let realm = try Realm()
        return realm.objects(T.self).map { $0 }
    }
    
    public class func delete<T: Object>(object: T) throws {
        let realm = try Realm()
        try realm.write {
            realm.delete(object)
        }
    }
    
    public class func delete<T: Object>(object: Results<T>) throws {
        let realm = try Realm()
        try realm.write {
            realm.delete(object)
        }
    }

    public class func clear() throws {
        let realm = try Realm()
        try realm.write {
            realm.deleteAll()
        }
    }
}
