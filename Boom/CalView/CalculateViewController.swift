//
//  CalculateViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/09.
//

import UIKit

class CalculateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var calItems: [CalculateItem] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalculateViewCell") as! CalculateViewCell
        cell.button_cell.layer.cornerRadius = 8
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

}

class CalculateViewCell: UITableViewCell {
    @IBOutlet weak var button_cell: UIButton!
    
}
