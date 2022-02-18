//
//  Caculator.swift
//  Caculator_SwiftUI
//
//  Created by 袁新杰 on 2021/10/26.
//

import Foundation

//enum basicOp {
//    case add(value : String)
//    case min(value : String)
//    case mul(value : String)
//    case div(value : String)
////    case equal = "="
//}

//struct calOperator {
//
//    var value: basicOp
//    var priority : Int
//}

var priority : [String:Int] = [
    "+" : 1,
    "−" : 1,
    "×" : 2,
    "÷" : 2,
    "=" : 0
    
]
struct CalculatorModel
{
    var numStack = myStack<Double>()
    var opStack = myStack<String>()
    var curNum : Int64 = 0
    var isDecimal : Bool = false
    var decemalPlace :Int = 0
    let decemalMaxPlace = 8
    var isPositive : Int = 1
    var preInputIsNum : Bool = true
    var numToShow : String = "0"
    
//    init(){
//        curDecimal = 0.0
//    }
    mutating func allClear(){
        numStack.clear()
        opStack.clear()
        curNum = 0
        isDecimal = false
        decemalPlace = 0
        isPositive = 1
        preInputIsNum = true
        numToShow = "0"
    }
    
    mutating func clearNum(){
        curNum = 0
        isDecimal = false
        decemalPlace = 0
        isPositive = 1
        preInputIsNum = true
//        numToShow = "0"
    }
    
    func getCurNum() -> Double{
        if(isDecimal){
            
           return Double(curNum * Int64(isPositive)) / pow(Double(10),Double(decemalPlace))
        }
        else{
            return Double(curNum * Int64(isPositive))
        }
    }
    mutating func pushNum(){
        numStack.push(getCurNum())
    }
    mutating func popOp() -> String{
        if(!opStack.isEmpty()){
            return opStack.pop()!
        }
        return ""
    }
    
    mutating func pushOp(_ calop : String){
        if(opStack.isEmpty() || priority[calop]!  > priority[opStack.peek()!]! ) {
            opStack.push(calop)
            
        }
        else{
            var tmp : Double = 0.0
            while(!opStack.isEmpty() &&
                  priority[opStack.peek()!]! >= priority[calop]! ){
                tmp = basicfunc(numStack.pop()!, by: opStack.pop()!, numStack.pop()!)
                numStack.push(tmp)
                
            }
            if(calop != "="){
                opStack.push(calop)
            }
            //update display
            if(abs(tmp - Double(Int(tmp))) < 1e-6){
                numToShow = String(Int(tmp))
            }
            else{
                numToShow = String(tmp)
            }
            
            
            
        }
    }
    mutating func basicfunc(_ secondNum : Double , by : String , _ firstNum : Double)-> Double{
        switch(by){
        case "+": do {
            return firstNum + secondNum
    //            break;
        }
        case "−": do{
            return firstNum - secondNum
    //            break
        }
        case "×" :do{
            return firstNum * secondNum
        }
        case "÷" :do{
            if(secondNum != 0){
                return firstNum / secondNum
            }
            else{
                allClear()
                numToShow = "error"
            }
        }
        
        default:
            numToShow = "basicfunc default"
            break
        }
        return 0.0
    }
    
    mutating func updateShowNum()
    {
        if(isDecimal)
        {
            if(decemalPlace > 0){
                var tmp : String = String(curNum)
                let numCount = tmp.count
                if(decemalPlace >= numCount)
                {
                    
                    tmp = strnCpy(str: "0", times: decemalPlace - numCount + 1)  + tmp
                }
                tmp.insert(".", at: tmp.index(tmp.endIndex ,offsetBy: -decemalPlace) )
                if(isPositive < 0){
                    tmp.insert("-", at: tmp.startIndex)
                }
               
                numToShow = tmp
            }
            else{
                numToShow = String(curNum * Int64(isPositive)) + "."
            }
        }
        else{
            numToShow = String(curNum * Int64(isPositive))
        }
    }
}


