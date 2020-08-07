//
//  LoginVC.swift
//  Pyramidion
//
//  Created by MacBook Pro on 2020-08-06.
//  Copyright © 2020 Peach. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSelectImage))
            userImageView.isUserInteractionEnabled = true
            userImageView.addGestureRecognizer(tap)
        }
    }
    
    private var _userImage: UIImage?
    
    private var userImage: UIImage? {
        get {
            return _userImage
        }
        set {
            _userImage = newValue
            if let img = newValue {
                userImageView.image = img
            }
        }
    }
    
    @objc
    private func onSelectImage(){
        print("HI HOW")
         openOptionToSelectPhoto()
    }
    
    @IBOutlet weak var emailTF: CustomTF! {
        didSet {
            emailTF.delegate = self
            emailTF.tag = 1
        }
    }
    
    private var email: String {
        get { return emailTF.text!}
        set {
            emailTF.text = newValue
        }
    }
    
    @IBOutlet weak var passwordTF: CustomTF! {
        didSet {
            passwordTF.delegate = self
            passwordTF.tag = 2
        }
    }
    
    private var password: String {
        get {
            return passwordTF.text!
        }
        set {
            passwordTF.text = newValue
        }
    }
    
    private var errorMessage = ""
    

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        view.addGestureRecognizer(tap)
        email = "a@b.ca"
        password = "Abcde@1987"
    }
    
    @objc func close(){
        view.endEditing(true)
    }
    
    @IBAction func onLoginPressed(_ sender: UIButton){
        view.endEditing(true)
        if validateForLogin(){
            performSegue(withIdentifier: LOGIN_TO_SHOW_TABLE, sender: self)
        }
        else {
            let alert: UIAlertController = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (action) in
                
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func validateForLogin() -> Bool {
        var isEmailValid = false
        var isPasswordValid = false
        var isImageSelected = false
        errorMessage = ""
        
        if isValidPassword(password){
            isPasswordValid = true
        }
        else {
            isPasswordValid = false
            errorMessage = "Password should contain at least one uppercase, lowercase, symbol, numeric and minimum 8 characters"
        }
        
        
        if isValidEmail(email){
            isEmailValid = true
        }
        else {
            isEmailValid = false
            errorMessage = "Invalid Email"
        }
        
        if userImage != nil {
            isImageSelected = true
        }
        else {
            isImageSelected = false
            errorMessage = "Please upload profile image"
        }
        
        
        var isValid = false
        if (isEmailValid && isPasswordValid && isImageSelected){
            isValid = true
        }
        
        return isValid
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passPred.evaluate(with: password)
    }
}

extension LoginVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func openOptionToSelectPhoto() {
        let camera = TWCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            emailTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        }
        else {
            passwordTF.resignFirstResponder()
        }
        return true
    }
}
