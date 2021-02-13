//
//  PageViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/11.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    let identifiers: NSArray = ["CalculateViewController", "GameViewController", "InformationViewController"]
    
    lazy var VCArray: [UIViewController] = []
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        let calVC = self.storyboard?.instantiateViewController(identifier: "CalculateViewController") as! CalculateViewController
        let gameVC = self.storyboard?.instantiateViewController(identifier: "GameViewController") as! GameViewController
        let informVC = self.storyboard?.instantiateViewController(identifier: "InformationViewController") as! InformationViewController
        
        VCArray.append(calVC)
        VCArray.append(gameVC)
        VCArray.append(informVC)
        
        if let firstVC = VCArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else { return nil }
//        let VC = UIApplication.topViewController() as! ViewController
        
        let previousIndex = viewControllerIndex - 1
        
        if previousIndex < 0 {
            return VCArray.last
        } else {
            return VCArray[previousIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
//        let VC = UIApplication.topViewController() as! ViewController
        
        if nextIndex >= VCArray.count {
            return VCArray.first
        } else {
            return VCArray[nextIndex]
        }
    }

}
