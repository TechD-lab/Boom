//
//  CalculateItems.swift
//  Boom
//
//  Created by 박진서 on 2021/02/12.
//

import UIKit

class CalculateItem {
    var name: String?   //어디서 술먹었나?
    var peoples: [people]?   //누가 참가했나?
    var totalCost: Int?  //총 얼마?
    var uid: String? // uid
}

struct people {
    var name: String?
    var uid: String?
    
    public mutating func setInfo (name: String, uid: String) {
        self.name = name
        self.uid = uid
    }
    
    var didCharge: Bool = false
    var usedMoney: Int?

}
