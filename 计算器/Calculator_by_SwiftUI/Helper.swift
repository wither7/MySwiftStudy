//
//  Helper.swift
//  Caculator_SwiftUI
//
//  Created by 袁新杰 on 2021/10/26.
//

import Foundation


class myStack<stackType> {
  var myarray: [stackType] = []
//  init() {
//    myarray = [Double]()
//  }
  func push(_ object: stackType) {
    myarray.append(object)
  }
    
  func pop() -> stackType? {
    if !isEmpty() {
      return myarray.removeLast()
    } else {
      return nil
    }
  }
  func isEmpty() -> Bool {
    return myarray.isEmpty
  }
  func peek() -> stackType? {
    return myarray.last
  }
  func size() -> Int {
    return myarray.count
  }
    func clear(){
        myarray.removeAll()
    }
}


 func strnCpy(str : String , times : Int)-> String{
    let tmp = str
    var res : String = String()
    for _ in 0..<times	{
        res += tmp
    }
    return res
}



