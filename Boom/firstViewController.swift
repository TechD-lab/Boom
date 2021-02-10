//
//  fisrtViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/09.
//

import UIKit
import XLPagerTabStrip

class firstViewController: ButtonBarPagerTabStripViewController{

    override func viewDidLoad() {
        loadDesign()
        super.viewDidLoad()
    }

    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let gameView = (self.storyboard?.instantiateViewController(identifier: "GameViewController"))! as gameViewController
        let informView = (self.storyboard?.instantiateViewController(identifier: "InformationViewController"))! as InformationViewController
        let calView = (self.storyboard?.instantiateViewController(identifier: "CalculateViewController"))!as CalculateViewController
        return [gameView, informView, calView]
    }
    
    func loadDesign() {

    }
    

    
}
