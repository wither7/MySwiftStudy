//
//  RunningSettingView.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/16.
//

import SwiftUI

struct RunningSettingView: View {
    let persistenceController = PersistenceController.shared
    @EnvironmentObject var settings : SettingsStorage
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    var body: some View {
        Toggle("以配速形式显示速度", isOn: $settings.storedSettings[0].usingPace)
                   .onChange(of: settings.storedSettings[0].usingPace) { value in
                    persistenceController.updateUserSetting(existingSetting: settings.storedSettings[0],
                                                            color: settings.storedSettings[0].color!,
                                                            usingPace: settings.storedSettings[0].usingPace,
                                                            deleteEnabled: settings.storedSettings[0].deleteEnabed,
                                                            BestLocation: settings.storedSettings[0].usingBestLocation)
                          
                   }
        Toggle("始终使用最高精度定位", isOn: $settings.storedSettings[0].usingBestLocation)
                   .onChange(of: settings.storedSettings[0].usingBestLocation) { value in
                    persistenceController.updateUserSetting(existingSetting: settings.storedSettings[0],
                                                            color: settings.storedSettings[0].color!,
                                                            usingPace: settings.storedSettings[0].usingPace,
                                                            deleteEnabled: settings.storedSettings[0].deleteEnabed,
                                                            BestLocation: settings.storedSettings[0].usingBestLocation)
                    
                          
                   }
        Toggle("实时绘制跑步轨迹", isOn: $settings.storedSettings[0].drawingMap)
                   .onChange(of: settings.storedSettings[0].usingBestLocation) { value in
                    persistenceController.updateUserSetting(existingSetting: settings.storedSettings[0],
                                                            color: settings.storedSettings[0].color!,
                                                            usingPace: settings.storedSettings[0].usingPace,
                                                            deleteEnabled: settings.storedSettings[0].deleteEnabed,
                                                            BestLocation: settings.storedSettings[0].usingBestLocation,
                                                            drawingMap: settings.storedSettings[0].drawingMap)
                   }
        
    }
}

struct RunningSettingView_Previews: PreviewProvider {
    static var previews: some View {
        RunningSettingView()
    }
}
