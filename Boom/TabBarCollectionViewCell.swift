//
//  TabBarCollectionViewCell.swift
//  Boom
//
//  Created by 박진서 on 2021/02/09.
//

import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TabBarCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    func setTitle(title: String) {
        titleLabel.text = title
    }
    override var isSelected: Bool {
        willSet {
            if newValue {
                titleLabel.textColor = .black
            } else {
                titleLabel.textColor = .lightGray }
        }
    }
    override func prepareForReuse() {
        isSelected = false }
}
