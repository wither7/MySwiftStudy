//
//  RecordListSettingView.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/16.
//

import SwiftUI

struct RecordListSettingView: View {
    let persistenceController = PersistenceController.shared
    @EnvironmentObject var settings : SettingsStorage
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    var body: some View {
        Toggle("可删除跑步记录", isOn: $settings.storedSettings[0].deleteEnabed)
            .onChange(of: settings.storedSettings[0].deleteEnabed) { value in
                persistenceController.updateUserSetting(existingSetting: settings.storedSettings[0],
                                                        color: settings.storedSettings[0].color!,
                                                        usingPace: settings.storedSettings[0].usingPace,
                                                        deleteEnabled: settings.storedSettings[0].deleteEnabed,
                                                        BestLocation: settings.storedSettings[0].usingBestLocation)
            }
        
    }
}

struct RecordListSettingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListSettingView()
    }
}
