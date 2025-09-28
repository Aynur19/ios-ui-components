//
//  View+Extensions.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 28.09.2025.
//

import SwiftUI

extension View {
    public func offset(_ offset: CGPoint) -> some View {
        self.offset(x: offset.x, y: offset.y)
    }
}
