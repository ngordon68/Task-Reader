//
//  TaskReaderApp.swift
//  TaskReader
//
//  Created by Nick Gordon on 10/12/22.
//

import SwiftUI

@main
struct TaskReaderApp: App {
    
    @StateObject private  var vm = AppViewModel()
    var body: some Scene {
        WindowGroup {
            MainPage()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}
