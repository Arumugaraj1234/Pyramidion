//
//  CustomCell.swift
//  Pyramidion
//
//  Created by MacBook Pro on 2020-08-06.
//  Copyright © 2020 Peach. All rights reserved.
//

import UIKit

protocol SwichChangeDelegate {
    func onSwitchStatusChanged(cell: CustomCell)
}

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    var delegate: SwichChangeDelegate?


    func configureCell(object: RowSwitch, index: Int, section: Int){
        label.text = "SECTION: \(section) - ROW: \(index)"
        switchBtn.isOn = object.switchStatus
    }
    
    @IBAction func onSwitchTapped(_ sender: UISwitch){
        delegate?.onSwitchStatusChanged(cell: self)
    }


}
