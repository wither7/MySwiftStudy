//
//  SettingView.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/13.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var runningState: RunningState
    
    var body: some View {
        NavigationView {
                  VStack {
                    if (runningState.isRunning) {
                          Text("处于跑步状态时不能修改设置，请先结束跑步")
                              .padding(.all, 10)
                      }
                      Form {
                          Section(header: Text("外观")) {
                              ColorView()
                             
                          }
                          .disabled(runningState.isRunning)

                          Section(header: Text("跑步设置")) {
                              RunningSettingView()
                          }
                          .disabled(runningState.isRunning)
                        
                          Section(header: Text("跑步记录设置")) {
                              RecordListSettingView()
                          }
                          .disabled(runningState.isRunning)
                        
                          Section(header: Text("重置")) {
                              ResetView()
                          }
                          .disabled(runningState.isRunning)
//                          Section(header: Text("About the app")) {
//                              AboutAppView()
//                          }
                      }
                      .navigationBarTitle(Text("设置"))
                  }
              }
              .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
