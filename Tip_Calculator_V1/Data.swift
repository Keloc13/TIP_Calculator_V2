//
//  Data.swift
//  Tip_Calculator_V1
//
//  Created by Kevin Nguyen on 12/18/17.
//  Copyright © 2017 KevinVuNguyen. All rights reserved.
//

import Foundation

class Data{
    static var DEBUG = true
    static var secondArray:[Double]=[0.15,0.25,0.30]
    
    static func getPercent(value: Int)->Double{
        if DEBUG{print("Data is being accessed")}
        return secondArray[value]
    }
    
    static func setPercent(value: Int, newPercent: Double){
        if DEBUG{print("Data has changed")}
        secondArray[value] = newPercent
    }
}

struct defaultKeys{
    static let key1 = "FirstKey"
    static let key2 = "SecondKey"
    static let keyTime = "TimeKey"
}
