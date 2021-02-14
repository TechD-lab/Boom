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
    let ref = Database.database().reference()
    var calVC: UIViewController?
    
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
        print(ref.child("Users").child(uid!).child("CalItems"))
    }
    
    func createCalItem() {
        
        //calItem 을 만들어서 데이터 집어넣고 DB에 푸쉬
        //calItem 모델 만들기
        let calitem = CalculateItem()
        calitem.name = "장소 이름"
        calitem.totalCost = 0

        let calItemInfo: Dictionary<String, Any> = [
            "name" : calitem.name!,
            "totalCost" : calitem.totalCost!,
            "uid" :         ref.child("Users").child(uid!).child("CalItems").childByAutoId().key!
        ]
        
        calitem.uid = calItemInfo["uid"] as? String
        //Firebase DB에 집어넣기
        ref.child("Users").child(uid!).child("CalItems").child(calItemInfo["uid"] as! String).setValue(calItemInfo)
        
        //calculateViewController 불러오기
        let calViewController = calVC as! CalculateViewController
        
        //calViewController   calItems 에 추가
        calViewController.calItems.append(calitem)
        
        //tableview 새로고침
        calViewController.tableView.reloadData()
    }
    
    @IBAction func change_clicked(_ sender: Any) {
        
//        ref.child("Users").child(uid!).observe(DataEventType.value) { (DataSnapshot) in
//            let myUid = Auth.auth().currentUser?.uid
            
//            for item in DataSnapshot.children {
//                let values = DataSnapshot.value
//                let dic = values as! [String: Any]
//                print(dic["CalItems"])
//            }
//        }
    }
}

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label_main: UILabel!
    @IBOutlet weak var image_bar: UIImageView!
        
}

// 최상위 뷰 컨트롤러 불러오기

// UIApplication.topViewController()  로 startViewController 부를 수 있음 어디서든

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
