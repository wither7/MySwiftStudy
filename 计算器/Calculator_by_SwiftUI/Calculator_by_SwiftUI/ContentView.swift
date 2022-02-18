//
//  ContentView.swift
//  Caculator_SwiftUI
//
//  Created by 袁新杰 on 2021/10/21.
//

import SwiftUI

    

var viewmodel = CalculatorVM()

struct ContentView: View {
    @ObservedObject var calViewModel = viewmodel
    
    var body: some View {
        VStack{
            VStack{
                Spacer()
                HStack(alignment: VerticalAlignment.bottom){
                    Spacer()
                    Text(String(calViewModel.getResult()) + "   ")
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                        .padding([.bottom, .trailing])
                        .frame( alignment: .trailing)
                }
            }
            Spacer()
            VStack{
                HStack{
                    Spacer()
                    unaryoperator(op: "C")
                    Spacer()
                    unaryoperator(op: "±")
                    Spacer()
                    unaryoperator(op: "%")
                    Spacer()
                    caloperator(op: "÷")
                    Spacer()
                }
                HStack{
                    Spacer()
                    num(num : 7)
                    Spacer()
                    num(num: 8)
                    Spacer()
                    num(num: 9)
                    Spacer()
                    caloperator(op: "×")
                    Spacer()
                }
                HStack{
                    Spacer()
                    num(num : 4)
                    Spacer()
                    num(num: 5)
                    Spacer()
                    num(num: 6)
                    Spacer()
                    caloperator(op: "−")
                    Spacer()
                }
                HStack{
                    Spacer()
                    num(num : 1)
                    Spacer()
                    num(num: 2)
                    Spacer()
                    num(num: 3)
                    Spacer()
                    caloperator(op: "+")
                    Spacer()
                }
                HStack{
                   
                    HStack{
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 50)
                                .fill(Color.gray)
                                //.frame(width: 60, height: 60    )
                              
                            Text(String(0))
                                .font(.largeTitle)
                                .padding()
                            
                        }
                        .onTapGesture {
                            calViewModel.numchoose(0)
                            
                            
                        }
                        Spacer()
                    }
                   
                    HStack{
                    Spacer()
                    dot()
                    Spacer()
                    caloperator(op: "=")
                    Spacer()
                    }
                }
            }
        }.padding()
        
    }
   
    
}


struct num : View{
    var num : Int64
    @ObservedObject var calViewModel = viewmodel
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.gray)
                //.frame(width: 60, height: 60    )
              
            Text(String(num))
                .font(.largeTitle)
                .padding()
            
        }
        .onTapGesture {
            calViewModel.numchoose(num)
            
        }
    }
}

struct dot : View{
    @ObservedObject var calViewModel = viewmodel
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.gray)
                
              
            Text(".")
                .font(.largeTitle)
                .padding()
            
        }
        .onTapGesture {
            calViewModel.dotChoose()
           
        }
    }

}
struct caloperator : View{
    @ObservedObject var calViewModel = viewmodel
    var op : String
    
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.orange)
                //.frame(width: 60, height: 60 )
              
            Text(op)
                .font(.largeTitle)
                .padding()
            
        }
        .onTapGesture {
            calViewModel.calOperatorChoose(op)
        }
    }
}

struct  unaryoperator : View {
    @ObservedObject var calViewModel = viewmodel
    var op :String
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.yellow)
                //.frame(width: 60, height: 60 )
              
            Text(op)
                .font(.title)
                .padding()
            
        }
        .onTapGesture {
            calViewModel.unaryChoose(op)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


