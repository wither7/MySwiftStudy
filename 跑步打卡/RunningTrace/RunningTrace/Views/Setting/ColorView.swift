//
//  ColorView.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/16.
//

import SwiftUI

struct ColorView: View {
    let persistenceController = PersistenceController.shared
    @EnvironmentObject var settings : SettingsStorage
    @Environment(\.managedObjectContext) private var managedObjectContext
    
       var body: some View {
        VStack{
        
            Picker("颜色", selection: $settings.storedSettings[0].colourChoiceConverted) {
               Text("红色").tag(ColourChoice.red)
               Text("橙色").tag(ColourChoice.orange)
               Text("黄色").tag(ColourChoice.yellow)
               Text("绿色").tag(ColourChoice.green)
               Text("蓝色").tag(ColourChoice.blue)
               Text("青色").tag(ColourChoice.indigo)
               Text("紫色").tag(ColourChoice.violet)
                   .navigationBarTitle("选择轨迹绘制颜色", displayMode: .inline)
                   .onChange(of: settings.storedSettings[0].colourChoiceConverted) { value in
                    persistenceController.updateUserSetting(existingSetting: settings.storedSettings[0],
                                                            color: settings.storedSettings[0].colourChoiceConverted.rawValue ,
                                                            usingPace: settings.storedSettings[0].usingPace,
                                                            deleteEnabled: settings.storedSettings[0].deleteEnabed,
                                                            BestLocation: settings.storedSettings[0].usingBestLocation)

                   }
           }
        }
       }
}



struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView()
    }
}
