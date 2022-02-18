//
//  ResetView.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/16.
//

import SwiftUI

struct ResetView: View {
    let persistenceController = PersistenceController.shared
    @EnvironmentObject var settings : SettingsStorage
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State var resetAlert = false
    @State var deleteAlert = false
    
    var body: some View {
        Button (action: {self.showResetToDefaultAlert()}) {
                 Text("恢复默认设置")
                     .foregroundColor(Color(MetricsFormat.convertColourChoiceToUIColor(colour: settings.storedSettings[0].colourChoiceConverted)))
             }
             .alert(isPresented: $resetAlert) {
                 Alert(title: Text("确定要将所有设置重制为初始设置吗？"),
                       message: Text(" "),
                       primaryButton: .destructive(Text("重制")) {
                         self.resetToDefaultSettings()
                       },
                       secondaryButton: .cancel(Text("取消"))
                 )
             }
        
        Button (action: {self.showDeleteAlert()}) {
                 Text("清除所有跑步记录")
                     .foregroundColor(Color(MetricsFormat.convertColourChoiceToUIColor(colour: settings.storedSettings[0].colourChoiceConverted)))
             }
             .alert(isPresented: $resetAlert) {
                 Alert(title: Text("确定要清除所有跑步记录吗？"),
                       message: Text(" "),
                       primaryButton: .destructive(Text("清除")) {
                        persistenceController.deleteAllRunRecords()
                       },
                       secondaryButton: .cancel(Text("取消"))
                 )
             }
    }
    
    func showResetToDefaultAlert(){
        self.resetAlert = true
    }
    
    func showDeleteAlert(){
        self.deleteAlert  = true
    }
    
    func resetToDefaultSettings(){
        persistenceController.updateUserSetting(existingSetting: settings.storedSettings[0], color: "Blue", usingPace: true, deleteEnabled: false, BestLocation: true)
    }
}

struct ResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetView()
    }
}
