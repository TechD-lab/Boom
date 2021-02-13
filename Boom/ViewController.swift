//
//  ViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/09.
//

import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    var menus: [String] = []
    var uid: String?
    var calItems: [CalculateItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menus.append("Main")
        menus.append("Games")
        menus.append("More")
        
        uid = Auth.auth().currentUser?.uid
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        touch(num: [0,0])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCollectionViewCell
        cell.label_main.text = menus[indexPath.row]
        cell.image_bar.backgroundColor = UIColor.systemGray4
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = UIScreen.main.bounds.width / 3
        let height: CGFloat = 50
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        touched(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        unTouched(indexPath: indexPath)
    }
    
    func touched(indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
        cell.image_bar.backgroundColor = UIColor.systemBackground
    }
    
    func unTouched(indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
        cell.image_bar.backgroundColor = UIColor.systemGray4
    }
    
    func touch(num: IndexPath) {
        switch num {
        case [0,0]:
            touched(indexPath: [0,0])
            unTouched(indexPath: [0,1])
            unTouched(indexPath: [0,2])
        case [0,1]:
            touched(indexPath: [0,1])
            unTouched(indexPath: [0,0])
            unTouched(indexPath: [0,2])
        case [0,2]:
            touched(indexPath: [0,2])
            unTouched(indexPath: [0,0])
            unTouched(indexPath: [0,1])
        default:
            touched(indexPath: [0,0])
            unTouched(indexPath: [0,1])
            unTouched(indexPath: [0,2])
        }
    }
    @IBAction func plus_clicked(_ sender: Any) {
        createCalItem()
    }
    
    @IBAction func search_clicked(_ sender: Any) {
        print(Database.database().reference().child("Users").child(uid!).child("CalItems"))
    }
    
    func createCalItem() {
        
        let calitem = CalculateItem()
        var people1 = people()
        people1.name = "zzoozzoon"
        people1.uid = 1
        var people2 = people()
        people2.name = "Goblin"
        people2.uid = 2
        calitem.name = "1차"
        calitem.peoples = [people1, people2]
        calitem.uid = 1
        calitem.totalCost = 75000
        
        var peopleInfo: Dictionary<String, Any> = [:]
        for human in calitem.peoples! {
            peopleInfo.updateValue(human.uid!, forKey: human.name!)
        }
        
        
        
        let calItemInfo: Dictionary<String, Any> = [
            "name" : calitem.name!,
            "peoples": peopleInfo,
            "totalCost": calitem.totalCost!
        ]
        Database.database().reference().child("Users").child(uid!).child("CalItems").child(String(calitem.uid!)).setValue(calItemInfo)
    }
    
    @IBAction func change_clicked(_ sender: Any) {
        
        Database.database().reference().child("Users").observe(DataEventType.value) { (DataSnapshot) in
            let myUid = Auth.auth().currentUser?.uid
            
            for child in DataSnapshot.children {
                let fchild = child as! DataSnapshot
                
                print(fchild.value(forKey: "CalItems"))
            }
        }
    }
}

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label_main: UILabel!
    @IBOutlet weak var image_bar: UIImageView!
        
}


extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
