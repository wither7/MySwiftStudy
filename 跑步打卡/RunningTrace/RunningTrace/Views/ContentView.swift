//
//  ContentView.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            RunningView()
                .tabItem{
                  Label("跑步", systemImage: "figure.walk")
                }
            RecordListView()
                .tabItem {
                    Label("历史记录" , systemImage : "list.dash")
                }
            SettingView()

                .tabItem {
                    Label("设置" , systemImage : "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
