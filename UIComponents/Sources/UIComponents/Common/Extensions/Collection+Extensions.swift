//
//  Collection+Extensions.swift
//  UIComponents
//
//  Created by Насыбуллин Айнур Анасович on 28.09.2025.
//

import Foundation

extension Collection {
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Element: SignedNumeric & Comparable {
    func closest(to value: Element) -> Element? {
        self.min(by: { abs($0 - value) < abs($1 - value) })
    }
}
