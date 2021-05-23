//
//  Data.swift
//  ArcView
//
//  Created by Gokhan Mutlu on 23.05.2021.
//

import Foundation

struct ArcData: CustomStringConvertible{
    var value:Double
    var description:String //title
    var isSelected:Bool = false
}

extension ArcData{
    init(_ value:Double, _ desc:String) {
        self.value = value
        description = desc
    }
}

extension ArcData{
    /**
     Sample data
     */
    static func all() -> [ArcData]{
        return [
            ArcData(value: 40, description: "Share"),
            ArcData(value: 25, description: "Time Deposits"),
            ArcData(value: 20, description: "Gold & Silver"),
            ArcData(value: 10, description: "Demand Deposits"),
            ArcData(value: 5, description: "Fund")
        ]
    }
}
