//
//  AddRowVC.swift
//  Pyramidion
//
//  Created by MacBook Pro on 2020-08-07.
//  Copyright © 2020 Peach. All rights reserved.
//

import UIKit

protocol SelectSectionDelegate {
    func onSectionSelected(section: Int)
}

class AddRowVC: UIViewController {
    
    var rowsCount: Int  = 0 {
        didSet {
            sectionsArray = rowsCount.getNosArray()
        }
    }
    
    var sectionsArray:[String] = []
    
    @IBOutlet weak var sectionTF: CustomTF! {
        didSet {
            sectionTF.delegate = self
        }
    }
    
    var selectedSection: String {
        get {return sectionTF.text!}
        set{
            sectionTF.text = newValue
        }
    }
    var delegate: SelectSectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func onAddButtonPressed(_ sender: UIButton){
        if selectedSection != "" {
            guard let sec = Int(selectedSection) else {return}
            delegate?.onSectionSelected(section: sec)
            navigationController?.popViewController(animated: true)
        }
    }

}

extension Int {
    func getNosArray() -> [String]{
        var tempArray = [String]()
        for i in 0...self-1 {
            tempArray.append("\(i)")
        }
        return tempArray
    }
}

extension AddRowVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setSectionSelectionPicker(_ sender: UITextField) {
        let sectioinSelectPicker = UIPickerView()
        sectioinSelectPicker.frame = CGRect(x: 0, y: self.view.frame.height - 180.0, width: self.view.frame.width, height: 180.0)
        sectioinSelectPicker.backgroundColor = UIColor.black
        sectioinSelectPicker.delegate = self
        sectioinSelectPicker.dataSource = self
        sectioinSelectPicker.tag = 1
        sectionTF.inputView = sectioinSelectPicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1: return sectionsArray.count
        default: return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerViewLabel = UILabel()
        pickerViewLabel.font = UIFont.systemFont(ofSize: 18.0)
        pickerViewLabel.numberOfLines = 0
        pickerViewLabel.lineBreakMode = .byCharWrapping
        pickerViewLabel.textColor = UIColor.white
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.backgroundColor = UIColor.black
        switch pickerView.tag {
        case 1:
            pickerViewLabel.text = sectionsArray[row]
        default:
            break
        }
        return pickerViewLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1: selectedSection = sectionsArray[row]
        default:
            break
        }
        view.endEditing(true)
    }
}

extension AddRowVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == sectionTF {
            selectedSection = sectionsArray[0]
            setSectionSelectionPicker(sectionTF)
        }
    }
}
