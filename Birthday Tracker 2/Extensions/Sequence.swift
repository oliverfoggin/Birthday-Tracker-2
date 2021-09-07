//
//  Sequence.swift
//  Sequence
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, using comparator: (T, T) -> Bool = (<)) -> [Element] {
        sorted(by: { a, b in
            return comparator(a[keyPath: keyPath], b[keyPath: keyPath])
        })
    }
}
