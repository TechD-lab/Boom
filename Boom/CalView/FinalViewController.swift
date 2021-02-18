//
//  FinalViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/17.
//

import UIKit

class FinalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "FinalCell") as! FinalCell
        
        return view
    }
    
    
}

class FinalCell : UITableViewCell {
    
}
