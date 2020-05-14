//
//  RegisterVC.swift
//  DemoFirebaseAuth
//
//  Created by ahmed gado on 5/13/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import UIKit
import Firebase
class RegisterVC: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    // MARK: - setUpView
    func setUpView(){
        setUpCornerRadious()
        setUpPadding()
        setUpPlaceHolder()
        setUpborderColor()
        setUpborderWidth()
        hideKeyboardWhenTappedAround()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handelAction))
        profileImage.addGestureRecognizer(tap)
    }
    // MARK: - handel Image Action
    @objc func handelAction (){
        print("Open Picker Image")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    // MARK: - setUpborderColor
    func setUpborderColor(){
        nameTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        emailTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        phoneTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        passwordTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        confirmPasswordTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    // MARK: - setUpborderWidth
    func setUpborderWidth(){
        nameTxt.layer.borderWidth = 0.4
        emailTxt.layer.borderWidth = 0.4
        phoneTxt.layer.borderWidth = 0.4
        passwordTxt.layer.borderWidth = 0.4
        confirmPasswordTxt.layer.borderWidth = 0.4
    }
    // MARK: - setUpCornerRadious
    func setUpCornerRadious(){
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        nameTxt.layer.cornerRadius = nameTxt.frame.height / 2
        passwordTxt.layer.cornerRadius = passwordTxt.frame.height / 2
        emailTxt.layer.cornerRadius = emailTxt.frame.height / 2
        phoneTxt.layer.cornerRadius = phoneTxt.frame.height / 2
        confirmPasswordTxt.layer.cornerRadius = confirmPasswordTxt.frame.height / 2
    }
    // MARK: - setUpPadding
    func setUpPadding(){
        nameTxt.setLeftPaddingPoints(10)
        nameTxt.setRightPaddingPoints(10)
        emailTxt.setLeftPaddingPoints(10)
        emailTxt.setRightPaddingPoints(10)
        phoneTxt.setLeftPaddingPoints(10)
        phoneTxt.setRightPaddingPoints(10)
        passwordTxt.setLeftPaddingPoints(10)
        passwordTxt.setRightPaddingPoints(10)
        confirmPasswordTxt.setLeftPaddingPoints(10)
        confirmPasswordTxt.setRightPaddingPoints(10)
    }
    // MARK: - setUpPlaceHolder
    func setUpPlaceHolder(){
        nameTxt.attributedPlaceholder = NSAttributedString(string: "Enter Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Enter Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        phoneTxt.attributedPlaceholder = NSAttributedString(string: "Enter Phone",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Enter Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        confirmPasswordTxt.attributedPlaceholder = NSAttributedString(string: "Enter Confirm Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    // MARK: - Validate
    func validation(){
        guard let email = emailTxt.text , !email.isEmpty else {return}
        guard let name = nameTxt.text , !name.isEmpty else {return}
        guard let phone = phoneTxt.text , !phone.isEmpty else {return}
        guard let password = passwordTxt.text , !password.isEmpty else {return}
        if password != confirmPasswordTxt.text {
            return
        }
        register(email: email, password: password, name:name, phone: phone )
    }
    // MARK: - register
    func register( email : String , password : String , name : String, phone : String){
        Auth.auth().createUser(withEmail: email, password: password) { (success, error) in
            if error == nil {
                // success
                guard let userId = success?.user.uid else {return}
                
                // upload image to storage
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("ProfileImage").child("\(imageName).png")
                if let imageData = self.profileImage.image?.jpegData(compressionQuality: 0.75) {
                    storageRef.putData(imageData, metadata: nil) { (success, error) in
                        if error != nil {
                            print(error ?? "error")
                            return
                        }
                        print(success ?? "success")
                        storageRef.downloadURL(completion: { (url, err) in
                            if let err = err {
                                print(err)
                                return
                            }
                            guard let url = url else { return }
                            let reference = Database.database().reference()
                            let user = reference.child("Users").child(userId)
                            let dataArray:[String: Any] = ["username": name , "userEmail": email , "userPhone" : phone , "userProfileURL": url.absoluteString  ]
                            user.setValue(dataArray)
                            self.goWelcome()
                        })
                    }
                }
                
                
            }else {
                // error
                print(error?.localizedDescription ?? "error")
            }
        }
        
    }
    func goWelcome(){
        let vc = storyboard?.instantiateViewController(identifier: "ViewController")  as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    // MARK: - IBAction
    @IBAction func haveAccountButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func registerButtonPressed(_ sender: Any) {
        validation()
    }
}
extension RegisterVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            print(editedImage.size)
            selectedImage = editedImage
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            print(originalImage.size)
            selectedImage = originalImage
        }
        profileImage.image = selectedImage
        dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Picker")
        dismiss(animated: true, completion: nil)
    }
}
