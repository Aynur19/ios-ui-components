//
//  Dictionary+Extensions.swift
//  UIComponents
//
//  Created by Насыбуллин Айнур Анасович on 28.09.2025.
//

import Foundation

extension Dictionary where Value: Comparable & SignedNumeric {
    /// Возвращает ключ для значения, ближайшего к переданному.
    func closestKey(to target: Value) -> Key? {
        self.min(by: { abs($0.value - target) < abs($1.value - target) })?.key
    }

    /// Возвращает пару (ключ, значение), ближайшую к переданному значению.
    func closestEntry(to target: Value) -> (Key, Value)? {
        self.min(by: { abs($0.value - target) < abs($1.value - target) })
    }
}
