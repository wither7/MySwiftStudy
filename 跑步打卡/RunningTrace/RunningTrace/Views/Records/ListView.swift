//
//  ListView.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/12.
//

import SwiftUI
import CoreData
//全局

struct RecordListView: View {
    let persistenceController = PersistenceController.shared
    @EnvironmentObject var settings : SettingsStorage
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State var dateAscending : Bool = false
//    @FetchRequest(
//        entity: RunRecord.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \RunRecord.runningDate, ascending: dateAscending)])
    @State var runRecords : [RunRecord] = []
    //    @State var runRecords : [RunRecord] = []
    @State var deleteAlert = false
    @State var indexSetToDelete : IndexSet?
    @State var confirmDelete = false
    
    init() {
        self.dateAscending = false
        self.populateRunRecords()
    }
    private func populateRunRecords(){
        self.runRecords = persistenceController.getAllRunRecords(dateAscending: dateAscending)
    }
    
    var body : some View {
        VStack{
//            Button(action: {
//                let tmpRun = RunRecord(context: managedObjectContext)
//                tmpRun.runningDate = Date()
//                tmpRun.runningDistance = "10.0"
//                tmpRun.runningPace = "3\'5\""
//                tmpRun.runningTime = 12.0
//
//                persistenceController.save()
//                self.populateRunRecords()
//            }, label: {
//                Text("Add Run")
//                    .font(.title)
//            })
            
            HStack{
                Text("跑步记录")
                    .font(.largeTitle)
                    .padding(.leading,150)
                Spacer()
                if(dateAscending){
                    Button("Date ↑"){
                        dateAscending.toggle()
                        self.populateRunRecords()
                    }
                    .padding(.trailing,20)
                }
                if(!dateAscending){
                    Button("Date ↓"){
                        dateAscending.toggle()
                        self.populateRunRecords()
                    }
                    .padding(.trailing,20)
                }
            }
            Divider()
            if (runRecords.count > 0) {
                List {
                    ForEach(self.runRecords , id: \.self) { runRecord in
                        VStack(spacing: 10) {
                            HStack {
                                Text(MetricsFormat.formatDate(date: runRecord.runningDate!) )
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            HStack {
                                Text("路程")
                                    .font(.title2)
                                Spacer()
                                Text((runRecord.runningDistance ?? "0.0") + "km")
                                    .font(.title)
                            }
                            HStack {
                                Text("时间")
                                    .font(.title2)
                                Spacer()
                                Text(MetricsFormat.formatTime(time: runRecord.runningTime))
                                    .font(.title)
                            }
                            HStack {
                                Text("配速")
                                    .font(.title2)
                                Spacer()
                                Text(runRecord.runningPace ?? "0\'0\"")
                                    .font(.title)
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        self.deleteAlert = true
                        self.indexSetToDelete = indexSet
                        
                    })
                    .alert(isPresented: self.$deleteAlert){
                        if(settings.storedSettings[0].deleteEnabed){
                            return Alert(title: Text("你确定要删除这条跑步记录吗？"),
                                         message: Text("该操作不可撤回"),
                                         primaryButton: .destructive(Text("删除")){
                                            self.confirmDelete = true
                                         },
                                         secondaryButton: .cancel(Text("取消")){
                                            self.confirmDelete = false
                                         })
                        }
                        else{
                            return Alert(title: Text("不允许删除跑步记录"),
                                         message: Text("可在设置界面更改权限"),
                                         dismissButton: .cancel(Text("OK")))
                        }
                    }
                    .onChange(of: self.confirmDelete , perform: {_ in
                        //删除
                        if(confirmDelete){
                            self.indexSetToDelete?.forEach { index in
                                
                                let record = self.runRecords[index]
                                persistenceController.deleteRunRecords(runRecord: record)
                                self.populateRunRecords()
                            }
                        }
                        self.confirmDelete = false
                        self.indexSetToDelete = nil
                    })
                    
                }
            }
            else {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("暂时没有跑步记录")
                            .font(.title)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .onAppear(perform: {
            self.populateRunRecords()
        })
        
    }
    
}



struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView()
    }
}
