//
//  CalculateItems.swift
//  Boom
//
//  Created by 박진서 on 2021/02/12.
//

import UIKit

class CalculateItem {
    var id: Int?  //정보 코드
    var name: String?   //어디서 술먹었나?
    var peoples: [people]?   //누가 참가했나?
    var totalCost: Int?  //총 얼마?
    var finalCost: Int?  //나눠서 얼마?
}

struct people {
    var name: String?
    var id: Int?
}
