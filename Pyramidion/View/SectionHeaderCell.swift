//
//  SectionHeaderCell.swift
//  Pyramidion
//
//  Created by MacBook Pro on 2020-08-07.
//  Copyright © 2020 Peach. All rights reserved.
//

import UIKit

class SectionHeaderCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    func configureSectionHeader(object: RowSwitch,section: Int){
        label.text = "SECTION: \(section)"
        switchBtn.tag = section
        switchBtn.isOn = object.switchStatus
    }

}
