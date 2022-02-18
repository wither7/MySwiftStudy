//
//  Caculator_ViewModel.swift
//  Caculator_SwiftUI
//
//  Created by 袁新杰 on 2021/10/26.
//

import Foundation
import SwiftUI

class CalculatorVM : ObservableObject
{
    @Published private var calModel =  CalculatorModel()
    
    func getResult ()-> String{
        return calModel.numToShow
    }
    func numchoose(_ chooseNum:Int64)
    {
        calModel.preInputIsNum = true
        if(calModel.decemalPlace >= calModel.decemalMaxPlace)
        {
            return
        }
        
        
        if(calModel.curNum < INT64_MAX / 10 - 1 ){//暂时不处理大数
            calModel.curNum = calModel.curNum*10 + chooseNum
        }
        
        if(calModel.isDecimal)
        {
            calModel.decemalPlace += 1
        }
        calModel.updateShowNum()
        
    }
    
    func dotChoose(){
        calModel.isDecimal = true
//        calModel.decemalPlace = 1
        calModel.updateShowNum()
    }
    func unaryChoose(_ unaryOp : String){
        switch(unaryOp){
        case "C" : do {
            calModel.allClear()
            break
        }
        case "±" : do {
            calModel.isPositive *= -1
            break
        }
        case "%" : do {
            calModel.isDecimal = true
            if(calModel.decemalPlace <= calModel.decemalMaxPlace){
                calModel.decemalPlace += 2
            }
            break
        }
        default:
            break
        }
        calModel.updateShowNum()
    }
    
    func calOperatorChoose(_ calOp : String)
    {
        
        
        if(calModel.preInputIsNum){
            calModel.pushNum()
            calModel.clearNum()
            calModel.preInputIsNum = false
            calModel.pushOp(calOp)
        }
        else{
            _ = calModel.popOp()
            calModel.pushOp(calOp)
        }
        
    }
    
    
}
