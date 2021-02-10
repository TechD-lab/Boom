//
//  ViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/09.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var menus: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menus.append("Main")
        menus.append("Games")
        menus.append("More")
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
        let height: CGFloat = 80
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
        cell.image_bar.backgroundColor = UIColor.systemBackground
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
        cell.image_bar.backgroundColor = UIColor.systemGray4
    }
}

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label_main: UILabel!
    @IBOutlet weak var image_bar: UIImageView!
}

