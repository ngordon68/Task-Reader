//
//  DataScannerView.swift
//  TaskReader
//
//  Created by Nick Gordon on 10/12/22.
//

import Foundation
import SwiftUI
import VisionKit

struct DataScannerView: UIViewControllerRepresentable {
    
    var itemsread:[RecognizedItem] = []
    @Binding var recongnizedItems: [RecognizedItem]
    let recongizedDataType: DataScannerViewController.RecognizedDataType
    let recongnizesMultipleItems: Bool
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [recongizedDataType],
            qualityLevel: .balanced,
            recognizesMultipleItems: recongnizesMultipleItems,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
            )
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recongnizedItems: $recongnizedItems)
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        @Binding var recongnizedItems: [RecognizedItem]
       
        init(recongnizedItems: Binding<[RecognizedItem]>) {
            self._recongnizedItems = recongnizedItems
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            print("didTapOn \(item)")
          
            
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            recongnizedItems.append(contentsOf: addedItems)
            print("didAddItems \(addedItems)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            self.recongnizedItems = recongnizedItems.filter { item in
                !removedItems.contains(where: {$0.id == item.id})
            }
            print("didRemovedItems \(removedItems)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("became unavailable with error \(error.localizedDescription)")
        }
        
        
        
    }
    
    
}
