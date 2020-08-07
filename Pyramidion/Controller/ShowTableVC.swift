//
//  ShowTableVC.swift
//  Pyramidion
//
//  Created by MacBook Pro on 2020-08-06.
//  Copyright © 2020 Peach. All rights reserved.
//

import UIKit

class ShowTableVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var headerSwitch: UISwitch!
    
    var sections = [[RowSwitch(switchStatus: false),RowSwitch(switchStatus: false),RowSwitch(switchStatus: false)], [RowSwitch(switchStatus: false),RowSwitch(switchStatus: false),RowSwitch(switchStatus: false)], [RowSwitch(switchStatus: false),RowSwitch(switchStatus: false),RowSwitch(switchStatus: false)]]
    
    var headerSections = [RowSwitch(switchStatus: false), RowSwitch(switchStatus: false), RowSwitch(switchStatus: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func onHeaderSwitchChanged(_ sender: UISwitch){
        if (sender.isOn) {
            for section in sections {
                for item in section {
                    item.switchStatus = true
                }
            }
            for head in headerSections {
                head.switchStatus = true
            }
        }
        else {
            for section in sections {
                for item in section {
                    item.switchStatus = false
                }
            }
            
            for head in headerSections {
                head.switchStatus = false
            }
        }
        tableView.reloadData()
    }
    
    
    
    
    @IBAction func onSectionHeaderSwitchTriggered(_ sender: UISwitch) {
        headerSections[sender.tag].switchStatus = !headerSections[sender.tag].switchStatus
        let rowsInSection = sections[sender.tag]
        for row in rowsInSection {
            row.switchStatus = headerSections[sender.tag].switchStatus
        }
        tableView.reloadData()
    }
    
    @IBAction func onPlusTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: TO_ADD_NEWROWVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_ADD_NEWROWVC {
            let addRowVc = segue.destination as! AddRowVC
            addRowVc.delegate = self
            addRowVc.rowsCount = headerSections.count
        }
    }
    
}

extension ShowTableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {return UITableViewCell()}
        let rowSwitch = sections[indexPath.section][indexPath.row]
        cell.configureCell(object: rowSwitch, index: indexPath.row, section: indexPath.section)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell") as? SectionHeaderCell else {return UIView()}
        let secSwitch = headerSections[section]
        cell.configureSectionHeader(object: secSwitch, section: section)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension ShowTableVC: SwichChangeDelegate {
    func onSwitchStatusChanged(cell: CustomCell) {
        
        let indexPath = tableView.indexPath(for: cell)
        if let path = indexPath {
            let item = sections[path.section][path.row]
            item.switchStatus = !item.switchStatus
            var isAllTrue = false
            for section in sections {
                for item in section {
                    if (item.switchStatus){
                        isAllTrue = true
                    }
                    else {
                        isAllTrue = false
                        break
                    }
                }
            }
            headerSwitch.isOn = isAllTrue
            
            for i in 0...sections.count - 1 {
                let rowsInsection = sections[i]
                var isAllRowsTrue = false
                innerloop: for row in rowsInsection {
                    if row.switchStatus == true {
                        isAllRowsTrue = true
                    }
                    else {
                        isAllRowsTrue = false
                        break innerloop
                    }
                    
                }
                headerSections[i].switchStatus = isAllRowsTrue
            }
            tableView.reloadData()
        }
        
        
    }
}

extension ShowTableVC: SelectSectionDelegate {
    func onSectionSelected(section: Int) {
        sections[section].append(RowSwitch(switchStatus: false))
        tableView.reloadData()
    }
    
    
}
