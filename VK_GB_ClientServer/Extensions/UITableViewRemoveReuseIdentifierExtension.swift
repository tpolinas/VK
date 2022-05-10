//
//  UITableViewRemoveReuseIdentifierExtension.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 26.04.2022.
//

import UIKit

public protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

public extension UITableView {
    func registerWithNib<T: UITableViewCell>(registerClass: T.Type) {
        let defaultReuseIdentifier = registerClass.defaultReuseIdentifier
        let nib = UINib(
            nibName: String(describing: registerClass.self),
            bundle: nil)
        register(
            nib,
            forCellReuseIdentifier: defaultReuseIdentifier)
    }
    
    func register<T: UITableViewCell>(registerClass: T.Type) {
        let defaultReuseIdentifier = registerClass.defaultReuseIdentifier
        register(
            registerClass,
            forCellReuseIdentifier: defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: T.defaultReuseIdentifier,
            for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(
        withIdentifier identifier: T.Type,
        forIndexPath indexPath: IndexPath
    ) -> T? {
        guard let cell = dequeueReusableCell(
            withIdentifier: T.defaultReuseIdentifier,
            for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

public extension UICollectionView {
    func registerWithNib<T: UICollectionViewCell>(registerClass: T.Type) {
        let defaultReuseIdentifier = registerClass.defaultReuseIdentifier
        let nib = UINib(
            nibName: String(describing: registerClass.self),
            bundle: nil)
        register(
            nib,
            forCellWithReuseIdentifier: defaultReuseIdentifier)
    }
}

public extension UICollectionView {
    func registerWithNibSectionHeader<T: UICollectionReusableView>(registerClass: T.Type) {
        let defaultReuseIdentifier = registerClass.defaultReuseIdentifier
        let nib = UINib(
            nibName: String(describing: registerClass.self),
            bundle: nil)
        register(
            nib,
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader,
            withReuseIdentifier: defaultReuseIdentifier)
    }
    
    func dequeueReusableSectionHeader<T: UICollectionReusableView>(
        withIdentifier identifier: T.Type,
        forIndexPath indexPath: IndexPath
    ) -> T? {
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.defaultReuseIdentifier,
            for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(
        withIdentifier identifier: T.Type,
        forIndexPath indexPath: IndexPath
    ) -> T? {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.defaultReuseIdentifier,
            for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell: ReusableView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView: ReusableView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView: ReusableView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewController: ReusableView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

