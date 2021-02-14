//
//  PageViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/11.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    lazy var VCArray: [UIViewController] = []
    let VC = UIApplication.topViewController() as! StartViewController

    var calVC: UIViewController?
    var gameVC: UIViewController?
    var informVC: UIViewController?
    
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        
        //최상단 뷰 컨트롤러  VC --> startViewController
        //VC.VC   ---> ViewController
        //ViewController 에서 CalculateViewController 을 불러오기 위해 여기서 선언을 해줌
        let viewController = VC.VC as! ViewController        
         calVC = self.storyboard?.instantiateViewController(identifier: "CalculateViewController") as! CalculateViewController
        viewController.calVC = calVC
        
         gameVC = self.storyboard?.instantiateViewController(identifier: "GameViewController") as! GameViewController
         informVC = self.storyboard?.instantiateViewController(identifier: "InformationViewController") as! InformationViewController
        
        VCArray.append(calVC!)
        VCArray.append(gameVC!)
        VCArray.append(informVC!)
        if let firstVC = VCArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else { return nil }
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
        if nextIndex >= VCArray.count {
            return VCArray.first
        } else {
            return VCArray[nextIndex]
        }
    }

}
