//
//  RunningTraceApp.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/9.
//

import SwiftUI
import CoreData

@main
struct RunningTraceApp: App {
   
    let persistenceController = PersistenceController.shared
    //全局变量：跑步状态
    @StateObject var runningState = RunningState()
    //用户设置
    @StateObject var settings : SettingsStorage
    
    init() {
            // Retrieve stored data to be used by all views - create state objects for environment objects
            let managedObjectContext = persistenceController.container.viewContext
            let userSettings = SettingsStorage(managedObjectContext: managedObjectContext)
            self._settings = StateObject(wrappedValue: userSettings)
            
          
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(runningState)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settings)
        }
    }
}
