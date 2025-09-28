//
//  FlexibleSheetView.swift
//  UIComponents
//
//  Created by Насыбуллин Айнур Анасович on 28.09.2025.
//

import SwiftUI

struct SheetOffsetModifier: Animatable {
    var offset: CGFloat
    var isVertical: Bool

    // AnimatableData отвечает за плавную анимацию
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }

//    func body(content: Content) -> some View {
//        content.offset(
//            x: isVertical ? 0 : offset,
//            y: isVertical ? offset : 0
//        )
//    }
}

public struct FlexibleSheetView<Content: View, ViewModel: FlexibleSheetViewModel>: View {
    @State private var offset: CGFloat = 0
    @State private var baseOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
//    private var animatableOffset: CGFloat

//    public var animatableData: CGFloat {
//        get { animatableOffset }
//        set { animatableOffset = newValue }
//    }
    
    @ObservedObject private var viewModel: ViewModel
    private let content: () -> Content
    
    public init(
        viewModel: ViewModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: sheeAlignment) {
            overlappedView
                .zIndex(0)
            
            contentView
                .allowsHitTesting(true)
                .zIndex(1)
        }
    }
    
    private var overlappedView: some View {
        Color.white.opacity(0.001)
            .ignoresSafeArea()
            .readSize {
                if viewModel.containerSize == .zero {
                    viewModel.setup(containerSize: $0)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.onOverlappedViewTapped()
            }
            .zIndex(0)
    }
    
    private var contentView: some View {
        ZStack {
            content()
                .safeFrame(size: viewModel.containerSize, alignment: sheeAlignment)
                .background(Color.orange.opacity(0.5))
                .clipShape(sheetShape)
                .contentShape(sheetShape)
                .offset(currentOffset)
                .animation(isDragging ? nil : viewModel.sheetExpandAnimation, value: offset)
                .onReceive(viewModel.sheetExpandStatePublisher) { state in
                    guard !isDragging else { return }
                    didUpdateSheetExapndState(state)
                }
                .if(viewModel.useSwipes) { view in
                    view
                        .gesture(
                            DragGesture(minimumDistance: 4)
                                .onChanged { value in
                                    if !isDragging {
                                        isDragging = true
                                    }
                                    
                                    let translation = isVertical ? value.translation.height : value.translation.width
                                    offset = baseOffset + translation
                                }
                                .onEnded {
                                    isDragging = false
                                    onEndedDragGesture(value: $0)
                                }
                        )
                }
                .onTapGesture {
                    viewModel.onSheetViewTapped()
                }
                
        }
    }
    
    private var isVertical: Bool {
        viewModel.sheetAnchor == .top || viewModel.sheetAnchor == .bottom
    }
    
    private var sheeAlignment: Alignment {
        switch viewModel.sheetAnchor {
        case .top:      Alignment.top
        case .bottom:   Alignment.bottom
        case .leading:  Alignment.leading
        case .trailing: Alignment.trailing
        }
    }
    
    private var currentOffset: CGPoint {
        if isVertical {
            CGPoint(x: 0, y: viewModel.clampedOffset(offset))
        } else {
            CGPoint(x: viewModel.clampedOffset(offset), y: 0)
        }
    }
        
    private var sheetShape: some Shape {
        RoundedRectangleShape(corners: viewModel.sheetRoundedCorners)
    }
    
    private func didUpdateSheetExapndState(_ state: SheetExpandState) {
//        if isDragging {
            offset = viewModel.getSheetOffset(expandState: state)
            baseOffset = offset
//        } else {
//            withAnimation(viewModel.sheetExpandAnimation) {
//                offset = viewModel.getSheetOffset(expandState: state)
//            }
//            baseOffset = offset
//        }
    }
    
    private func onEndedDragGesture(value: DragGesture.Value) {
        let predictedOffset = offset + value.predictedEndTranslation.height
        
        viewModel.updateExpandState(predictedOffset: predictedOffset)
    }
}
