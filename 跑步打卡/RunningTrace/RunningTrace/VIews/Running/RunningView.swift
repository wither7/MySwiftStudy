//
//  RunningView.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/10.
//

import SwiftUI

struct RunningView: View {
    @EnvironmentObject var runningState : RunningState
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var settings : SettingsStorage
    let persistenceController = PersistenceController.shared
    
    @StateObject var locationManager = LocationViewModel.locationManager
    @StateObject var timer = TimerViewModel()
    @State private var runningStartDate = Date()
//    @State var runningTime = 0.0
    
    @State var stopAlert : Bool = false
    
    @GestureState var isLongPressed = false
    
    init() {
        
    }
    var body: some View {
        let longPressGesture = LongPressGesture(minimumDuration: 1.5)
            .updating($isLongPressed){newValue , state , transaction in
                state = newValue
                
            }
            .onEnded(){_ in
                self.confirmStop()
            }
        
        VStack{
            ZStack(alignment: .bottom){
                MapView()
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                                    print("moving to background")
                        locationManager.changeToBackground(usingBestLocation: settings.storedSettings[0].usingBestLocation)
                                })
                                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
                                    print("moving to foreground")
                                    locationManager.changeToForeground()
                                })
                
                HStack{
                    Spacer()
                    if (timer.isStopped) {//开始跑步
                        Button (action: {self.startRunning()}) {
                            TimerButton(label: "开始", buttonColour: UIColor.systemGreen)
                                .padding(.bottom , 20)
                                .minimumScaleFactor(0.3)
                                .lineLimit(1)
                        }                        
                    }
                    if (timer.isRunning) {//暂停
                        Button (action: {self.pauseRunning()}) {
                            TimerButton(label: "暂停", buttonColour: UIColor.systemYellow)
                                .padding(.bottom, 20)
                                .minimumScaleFactor(0.3)
                                .lineLimit(1)
                        }
                    }
                    if(timer.isPaused){//继续跑步或终止跑步
                        Button (action: {self.resumeRunning()}) {
                            TimerButton(label: "继续", buttonColour: UIColor.systemGreen)
                                .padding(.bottom, 20)
                                .minimumScaleFactor(0.3)
                                .lineLimit(1)
                        }
                        Spacer()
                        
                        TimerButton(label: "终止", buttonColour: isLongPressed ? UIColor.systemGreen : UIColor.systemRed)
                            .padding(.bottom, 20)
                            .minimumScaleFactor(0.3)
                            .lineLimit(1)
//                            .background(Color(isLongPressed ? UIColor.systemGreen : UIColor.systemRed))
                            .gesture(longPressGesture)
                    }
                    Spacer()
                }
                
            }
            HStack(){
//                Spacer()
                VStack{
                    Text(self.getPace(isPace: settings.storedSettings[0].usingPace))
                        .font(.custom("Avenir", size: 30))
                    Text("配速")
                        .font(.custom("Avenir", size: 20))
                }
                .padding(.leading , 10)
                Divider()
//                Spacer()
                VStack{
                    Text(formatTimeString(accumulatedTime: timer.totalAccumulatedTime))
                        .font(.custom("Avenir", size: 30))
                    Text("时间")
                        .font(.custom("Avenir", size: 20))
                }
                Divider()
                VStack{
                    Text(self.getDistance())
                        .font(.custom("Avenir", size: 30))
                    Text("路程")
                        .font(.custom("Avenir", size: 20))
                }
//                Spacer()
            }
            .frame(height: 100.0)
            
        }
        .alert(isPresented: $stopAlert) {
            Alert(title: Text("确定要结束本次跑步吗？"),
                  message: Text("要结束本次跑步活动，请点击确认按钮"),
                  primaryButton: .default(Text("确认")) {
                    
                   
                    //保存本次跑步记录
                    persistenceController.storeRunRecord(pace:self.getPace(isPace: true),
                                                         distance: String(format: "%.2f", self.locationManager.runningTotalDistance / 1000.0 ),
                                                         startDate: self.runningStartDate,
                                                         time: self.timer.totalAccumulatedTime)
                    //清空历史
                    self.timer.stop()
                    runningState.stopRun()
                    self.locationManager.stopLocating()
                    self.locationManager.clearLocationArray()
                  },
                  secondaryButton: .cancel(Text("取消"))
            )
        }
    }
    
    
    
    
    func formatTimeString(accumulatedTime: TimeInterval) -> String {
        let hours = Int(accumulatedTime) / 3600
        let minutes = Int(accumulatedTime) / 60 % 60
        let seconds = Int(accumulatedTime) % 60
        let res = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        print(res)
        return res
    }
    
    func startRunning() {
        
        self.runningState.startRun()
//        self.runningStartDate = Date()
        self.timer.start()
        locationManager.startLocating()
    }
    
    func pauseRunning() {
        
        self.timer.pause()
        self.locationManager.stopLocating()
    }
    
    func resumeRunning(){
        self.timer.start()
        self.locationManager.startLocating()
        
    }
    
    func confirmStop() {
        self.timer.pause()
        self.stopAlert = true
    }
    
    //根据速度计算配速
    func getPace(isPace : Bool) -> String{
        return MetricsFormat.formatAverageSpeed(distance: self.locationManager.runningTotalDistance,
                                                time: self.timer.totalAccumulatedTime ,
                                                usingPace: isPace)
    }
    
    func getDistance() -> String{
        let s = String(format: "%.2f", self.locationManager.runningTotalDistance / 1000.0 )
        return "\(s) km"
    }
}

struct TimerButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let label: String
    let buttonColour: UIColor
    
    var body: some View {
        
        Text(label)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
            .background(Color(buttonColour))
            .cornerRadius(12)
        
    }
}






struct RunningView_Previews: PreviewProvider {
//    let persistenceController = PersistenceController.shared
    static var previews: some View {
        RunningView()
            .environmentObject(RunningState())
//            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
