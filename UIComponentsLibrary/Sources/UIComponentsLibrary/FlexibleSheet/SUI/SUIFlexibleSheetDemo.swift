//
//  SUIFlexibleSheetDemo.swift
//  UIComponentsLibrary
//
//  Created by Насыбуллин Айнур Анасович on 28.09.2025.
//

#if DEBUG
import SwiftUI


struct SUIFlexibleSheetDemo_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUIDemoFlexibleBottomSheetHostView()
                .ignoresSafeArea()
        }
//
//            .previewDevice("iPhone 15")
    }
}

struct SUIDemoFlexibleBottomSheetHostView: View {
    @StateObject private var vm = SUIFlexibleSheetViewModelImpl.createBottomSheetViewModel(
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
            
            SUIFlexibleSheetView(
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

struct SUIDemoFlexibleTopSheetHostView: View {
    @StateObject private var vm = SUIFlexibleSheetViewModelImpl.createTopSheetViewModel(
        cornerRadius: 50,
        sheetMinOffset: 100
    )

    var body: some View {
        SUIFlexibleSheetView(viewModel: vm) {
            VStack {
                Spacer()
                Text("Hello Sheet")
                Spacer()
            }
        }
    }
}

struct SUIDemoFlexibleRightSheetHostView: View {
    @StateObject private var vm = SUIFlexibleSheetViewModelImpl.createRightSheetViewModel(
        cornerRadius: 50,
        sheetMinOffset: 100
    )

    var body: some View {
        SUIFlexibleSheetView(viewModel: vm) {
            VStack {
                Spacer()
                Text("Hello Sheet")
                Spacer()
            }
        }
    }
}

struct SUIDemoFlexibleLeftSheetHostView: View {
    @StateObject private var vm = SUIFlexibleSheetViewModelImpl.createLeftSheetViewModel(
        cornerRadius: 50,
        sheetMinOffset: 100
    )

    var body: some View {
        SUIFlexibleSheetView(viewModel: vm) {
            VStack {
                Spacer()
                Text("Hello Sheet")
                Spacer()
            }
        }
    }
}
#endif
