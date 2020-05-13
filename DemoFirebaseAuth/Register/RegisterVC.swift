//
//  RegisterVC.swift
//  DemoFirebaseAuth
//
//  Created by ahmed gado on 5/13/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func haveAccountButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func registerButtonPressed(_ sender: Any) {
    }
}
