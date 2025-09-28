//
//  FlexibleSheetDemo.swift
//  UIComponents
//
//  Created by Насыбуллин Айнур Анасович on 28.09.2025.
//

#if DEBUG
import SwiftUI


struct FlexibleSheetDemo_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            DemoFlexibleBottomSheetHostView()
                .ignoresSafeArea()
        }
//
//            .previewDevice("iPhone 15")
    }
}

struct DemoFlexibleBottomSheetHostView: View {
    @StateObject private var vm = FlexibleSheetViewModelImpl.createBottomSheetViewModel(
        cornerRadius: 50,
        sheetMinOffset: 100
    )
    
    var body: some View {
        ZStack {
            Color.secondary
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                //                Text("Offset: \(bottomSheetVM.sheetOffset)").padding()
                Spacer()
            }
            
            FlexibleSheetView(
                viewModel: vm,
                content: { sheetcontent }
            )
            .ignoresSafeArea()
        }
    }
    
    private var sheetcontent: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Sheet content")
                Spacer()
            }
            Spacer()
        }
    }
}

struct DemoFlexibleTopSheetHostView: View {
    @StateObject private var vm = FlexibleSheetViewModelImpl.createTopSheetViewModel(
        cornerRadius: 50,
        sheetMinOffset: 100
    )

    var body: some View {
        FlexibleSheetView(viewModel: vm) {
            VStack {
                Spacer()
                Text("Hello Sheet")
                Spacer()
            }
        }
    }
}

struct DemoFlexibleRightSheetHostView: View {
    @StateObject private var vm = FlexibleSheetViewModelImpl.createRightSheetViewModel(
        cornerRadius: 50,
        sheetMinOffset: 100
    )

    var body: some View {
        FlexibleSheetView(viewModel: vm) {
            VStack {
                Spacer()
                Text("Hello Sheet")
                Spacer()
            }
        }
    }
}

struct DemoFlexibleLeftSheetHostView: View {
    @StateObject private var vm = FlexibleSheetViewModelImpl.createLeftSheetViewModel(
        cornerRadius: 50,
        sheetMinOffset: 100
    )

    var body: some View {
        FlexibleSheetView(viewModel: vm) {
            VStack {
                Spacer()
                Text("Hello Sheet")
                Spacer()
            }
        }
    }
}
#endif
