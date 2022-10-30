//
//  ContentView.swift
//  TaskReader
//
//  Created by Nick Gordon on 10/12/22.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel
    
    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        
        ("All", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
        ("Address", . fullStreetAddress)
    ]
    
    var body: some View {
        switch vm.dataScannerAccessStatus {
        case .scannerAvailable:
            mainView
        case .cameraNotAvailable:
            Text("Your device doesn't have camera")
        case .scannerNotAvailable:
            Text("Your device doesn't have support for scanning barcode with this app")
        case .cameraAccessNotGranted:
            Text("Please provide access to the camera in settings")
        case .notDetermined:
            Text("Requesting camera access")
        }
    }
    
    
    private var mainView: some View {
        VStack {
             topHeaderView
            
            DataScannerView(recongnizedItems: $vm.recongnizedItems,
                            recongizedDataType: vm.recongnizedDataType,
                            recongnizesMultipleItems: vm.recongnizesMultipleItems)
            .background {( Color.gray.opacity(0.3)) }
            .ignoresSafeArea()
            .id(vm.dataScannerViewID)
            .sheet(isPresented: .constant(true)) {
                bottomContainerView
                    .background(.ultraThinMaterial)
                    .presentationDetents([.medium, .fraction(0.25)])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled()
                    .onAppear {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                            return
                        }
                        controller.view.backgroundColor = .clear
                    }
            }
            .onChange(of: vm.scanType, perform: { _ in vm.recongnizedItems = [] })
            .onChange(of: vm.textContentType, perform: { _ in vm.recongnizedItems = [] })
            .onChange(of: vm.recongnizesMultipleItems, perform: { _ in vm.recongnizedItems = [] })
        }
    }
    private var topHeaderView: some View {
        VStack {
          NavigationLink("Home", destination: MainPage())
        }
    }
    
    private var headerView: some View {
        
        VStack {
          
            HStack {
              
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }.pickerStyle(.segmented)
                
                Toggle("Scan Multiple", isOn: $vm.recongnizesMultipleItems)
                
            }.padding(.top)
            
            if vm.scanType == .text {
                Picker("Text context type", selection: $vm.textContentType) {
                    ForEach(textContentTypes, id: \.self.textContentType) { option in
                        Text(option.title).tag(option.textContentType)
                    }
                }.pickerStyle(.segmented)
            }
            Text(vm.headerText).padding(.top)
            
        }.padding(.horizontal)
    }
    private var bottomContainerView: some View {
        VStack {
            headerView
            ScrollView {
                
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.recongnizedItems) { item in
                        switch item {
                        case .barcode(let barcode):
                            Text(barcode.payloadStringValue ?? "Unknown barcode")
                            
                        case.text(let text):
                            Text(text.transcript)
                            
                        @unknown default:
                            Text("Unknown")
                        }
                        
                    }
                }.padding()
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
           
    }
}
