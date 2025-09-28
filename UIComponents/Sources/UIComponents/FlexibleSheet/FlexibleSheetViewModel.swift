//
//  File.swift
//  UIComponents
//
//  Created by Насыбуллин Айнур Анасович on 28.09.2025.
//

import SwiftUI
import Combine

public protocol FlexibleSheetViewModel: ObservableObject, AnyObject {
    var containerSize: CGSize { get }
    var sheetExpandStatePublisher: AnyPublisher<SheetExpandState, Never> { get }
        
    var sheetAnchor: SheetAnchor { get }
    var sheetExpandMode: SheetExpandMode { get }
    var sheetRoundedCorners: SheetRoundedCorners { get }
    var sheetExpandAnimation: Animation { get }
    var sheetMinOffset: CGFloat { get }
    var sheetOffsets: [SheetExpandState: CGFloat] { get }
    
    var useSwipes: Bool { get }
        
    var offsetForMax: CGFloat { get }
    var offsetForMin: CGFloat { get }
    var offsetForMid: CGFloat { get }
        
    var minOffset: CGFloat { get }
    var maxOffset: CGFloat { get }
    
    init(
        sheetAnchor: SheetAnchor,
        sheetExpandMode: SheetExpandMode,
        sheetExpandState: SheetExpandState,
        sheetRoundedCorners: SheetRoundedCorners,
        sheetExpandAnimation: Animation,
        sheetMinOffset: CGFloat,
        useSwipes: Bool
    )
        
    @MainActor
    func setup(containerSize: CGSize)

    @MainActor
    func update(sheetExpandState: SheetExpandState)
        
    @MainActor
    func onSheetViewTapped()
        
    @MainActor
    func onOverlappedViewTapped()
    
    @MainActor
    func updateExpandState(predictedOffset: CGFloat)

    func getSheetOffset(expandState: SheetExpandState) -> CGFloat
        
    func clampedOffset(_ offset: CGFloat) -> CGFloat
    
    static func createBottomSheetViewModel(cornerRadius: CGFloat, sheetMinOffset: CGFloat) -> Self
    
    static func createTopSheetViewModel(cornerRadius: CGFloat, sheetMinOffset: CGFloat) -> Self
    
    static func createRightSheetViewModel(cornerRadius: CGFloat, sheetMinOffset: CGFloat) -> Self
    
    static func createLeftSheetViewModel(cornerRadius: CGFloat, sheetMinOffset: CGFloat) -> Self
}

extension FlexibleSheetViewModel {
    public init(
        sheetAnchor: SheetAnchor,
        sheetRoundedCorners: SheetRoundedCorners,
        sheetMinOffset: CGFloat
    ) {
        self.init(
            sheetAnchor: sheetAnchor,
            sheetExpandMode: SheetExpandMode.minMax,
            sheetExpandState: SheetExpandState.min,
            sheetRoundedCorners: sheetRoundedCorners,
            sheetExpandAnimation: Animation.spring(response: 1, dampingFraction: 1),
            sheetMinOffset: sheetMinOffset,
            useSwipes: true
        )
    }
    
    public static func createBottomSheetViewModel(cornerRadius: CGFloat, sheetMinOffset: CGFloat) -> Self {
        Self(
            sheetAnchor: .bottom,
            sheetRoundedCorners: SheetRoundedCorners(
                topLeftRadius: cornerRadius,
                topRightRadius: cornerRadius
            ),
            sheetMinOffset: sheetMinOffset
        )
    }
    
    public static func createTopSheetViewModel(cornerRadius: CGFloat, sheetMinOffset: CGFloat) -> Self {
        Self(
            sheetAnchor: .top,
            sheetRoundedCorners: SheetRoundedCorners(
                bottomLeftRadius: cornerRadius,
                bottomRightRadius: cornerRadius
            ),
            sheetMinOffset: sheetMinOffset
        )
    }
    
    public static func createRightSheetViewModel(cornerRadius: CGFloat, sheetMinOffset: CGFloat) -> Self {
        Self(
            sheetAnchor: .trailing,
            sheetRoundedCorners: SheetRoundedCorners(
                topLeftRadius: cornerRadius,
                bottomLeftRadius: cornerRadius
            ),
            sheetMinOffset: sheetMinOffset
        )
    }
    
    public static func createLeftSheetViewModel(cornerRadius: CGFloat, sheetMinOffset: CGFloat) -> Self {
        Self(
            sheetAnchor: .leading,
            sheetRoundedCorners: SheetRoundedCorners(
                topRightRadius: cornerRadius,
                bottomRightRadius: cornerRadius
            ),
            sheetMinOffset: sheetMinOffset
        )
    }
}

public final class FlexibleSheetViewModelImpl: FlexibleSheetViewModel {
    @Published public private(set) var containerSize: CGSize = .zero
    @Published private var sheetExpandState: SheetExpandState
    
    public let sheetAnchor: SheetAnchor
    public let sheetExpandMode: SheetExpandMode
    public let sheetExpandAnimation: Animation
    public let sheetRoundedCorners: SheetRoundedCorners
    public let sheetMinOffset: CGFloat
    public let useSwipes: Bool
    
    public private(set) var offsetForMax: CGFloat = .zero
    public private(set) var offsetForMin: CGFloat = .zero
    public private(set) var offsetForMid: CGFloat = .zero
    
    public private(set) var minOffset: CGFloat = .zero
    public private(set) var maxOffset: CGFloat = .zero
    
    public private(set) var sheetOffsets: [SheetExpandState: CGFloat] = [:]
    
    public init(
        sheetAnchor: SheetAnchor,
        sheetExpandMode: SheetExpandMode,
        sheetExpandState: SheetExpandState,
        sheetRoundedCorners: SheetRoundedCorners,
        sheetExpandAnimation: Animation,
        sheetMinOffset: CGFloat,
        useSwipes: Bool
    ) {
        self.sheetAnchor = sheetAnchor
        self.sheetExpandMode = sheetExpandMode
        self.sheetExpandState = sheetExpandState
        self.sheetRoundedCorners = sheetRoundedCorners
        self.sheetExpandAnimation = sheetExpandAnimation
        self.sheetMinOffset = sheetMinOffset
        self.useSwipes = useSwipes
    }
    
    public var sheetExpandStatePublisher: AnyPublisher<SheetExpandState, Never> {
        $sheetExpandState.eraseToAnyPublisher()
    }
    
    public func setup(containerSize: CGSize) {
        setup(anchor: sheetAnchor, containerSize: containerSize)
        sheetExpandState = SheetExpandState.min
    }
    
    private func setup(anchor: SheetAnchor, containerSize: CGSize) {
        self.containerSize = containerSize
        
        switch anchor {
        case .top:
            self.offsetForMin = -containerSize.height + sheetMinOffset
            self.offsetForMax = 0
            self.offsetForMid = offsetForMin / 2
            
            self.minOffset = offsetForMin
            self.maxOffset = offsetForMax
            
        case .bottom:
            self.offsetForMin = containerSize.height - sheetMinOffset
            self.offsetForMid = offsetForMin / 2
            self.offsetForMax = 0
            
            self.minOffset = offsetForMax
            self.maxOffset = offsetForMin
        
        case .leading:
            self.offsetForMin = -containerSize.width + sheetMinOffset
            self.offsetForMid = offsetForMin / 2
            self.offsetForMax = 0
            
            self.minOffset = offsetForMin
            self.maxOffset = offsetForMax
        
        case .trailing:
            self.offsetForMin = containerSize.width - sheetMinOffset
            self.offsetForMid = offsetForMin / 2
            self.offsetForMax = 0
            
            self.minOffset = offsetForMax
            self.maxOffset = offsetForMin
        }
        
        self.sheetOffsets[SheetExpandState.max] = offsetForMax
        self.sheetOffsets[SheetExpandState.min] = offsetForMin
        
        if case .minMidMax = sheetExpandMode {
            self.sheetOffsets[SheetExpandState.mid] = offsetForMid
        }
    }

    public func update(sheetExpandState: SheetExpandState) {
        self.sheetExpandState = sheetExpandState
    }
    
    public func onSheetViewTapped() {
        update(sheetExpandState: SheetExpandState.max)
    }
    
    public func onOverlappedViewTapped() {
        update(sheetExpandState: SheetExpandState.min)
    }
    
    public func updateExpandState(predictedOffset: CGFloat) {
        switch sheetExpandMode {
        case .minMax:
            sheetExpandState = sheetOffsets.closestEntry(to: predictedOffset)?.0 ?? sheetExpandState
        
        case .minMidMax:
            sheetExpandState = sheetOffsets.closestEntry(to: predictedOffset)?.0 ?? sheetExpandState
        
        case .dragging:
            sheetExpandState = SheetExpandState.custom(offset: predictedOffset)
        }
    }

    public func getSheetOffset(expandState: SheetExpandState) -> CGFloat {
        switch expandState {
        case .min: offsetForMin
        case .mid: offsetForMid
        case .max: offsetForMax
        case let .custom(offset):
            offset
        }
    }
    
    public func clampedOffset(_ offset: CGFloat) -> CGFloat {
        min(maxOffset, max(minOffset, offset))
    }
}
