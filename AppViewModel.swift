//
//  AppViewModel.swift
//  TaskReader
//
//  Created by Nick Gordon on 10/12/22.
//

import Foundation
import SwiftUI
import VisionKit
import AVKit


enum ScanType: String {
    case text, barcode
}

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
    
}

@MainActor
final class AppViewModel: ObservableObject {
  
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recongnizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .barcode
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recongnizesMultipleItems = true
    
     var recongnizedDataType: DataScannerViewController.RecognizedDataType {
        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
    }
    
    var headerText: String {
        if recongnizedItems.isEmpty {
            return "Scanning \(scanType.rawValue)"
        } else {
            return "Recongnized \(recongnizedItems.count) items(s)"
        }
    }
    
    
    var dataScannerViewID: Int {
        var hasher = Hasher()
        hasher.combine(scanType)
        hasher.combine(recongnizesMultipleItems)
        if let textContentType {
            hasher.combine(textContentType)
        }
        return hasher.finalize()
    }
     var isScannerAvailable: Bool {
         DataScannerViewController.isAvailable && DataScannerViewController.isSupported
        
    }
    
    func requestDataScannerAccessStatus() async {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera)
        else {
            dataScannerAccessStatus = .cameraNotAvailable
            return
        }
       
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable: .scannerNotAvailable
            
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable: .scannerNotAvailable
            } else {
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
        default: break
            
        }
    }
}


