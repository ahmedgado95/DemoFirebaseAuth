//
//  LoginVC.swift
//  DemoFirebaseAuth
//
//  Created by ahmed gado on 5/12/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FirebaseAuth
class LoginVC: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var emailPhoneTxt: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var faceBookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    // MARK: - variables
    var code =  ""
    enum TypeOfUserInput: Int {
        case email
        case phone
    }
    var typeOfUserInput: TypeOfUserInput  = .email
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        // Do any additional setup after loading the view.
    }
    // MARK: - setUpView
    func setUpView(){
        setUpCornerRadious()
        setUpPadding()
        setUpPlaceHolder(text: " Enter Email")
        setupSegmentedControl()
        setUpborderColor()
        setUpborderWidth()
        hideKeyboardWhenTappedAround()
    }
    // MARK: - setUpborderColor
    func setUpborderColor(){
        emailPhoneTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        passwordTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    // MARK: - setUpborderWidth
    func setUpborderWidth(){
        emailPhoneTxt.layer.borderWidth = 0.4
        passwordTxt.layer.borderWidth = 0.4
    }
    // MARK: - setUpCornerRadious
    func setUpCornerRadious(){
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        emailPhoneTxt.layer.cornerRadius = emailPhoneTxt.frame.height / 2
        passwordTxt.layer.cornerRadius = passwordTxt.frame.height / 2
        faceBookLoginButton.layer.cornerRadius = faceBookLoginButton.frame.height / 2
        googleLoginButton.layer.cornerRadius = googleLoginButton.frame.height / 2
        appleLoginButton.layer.cornerRadius = appleLoginButton.frame.height / 2
    }
    // MARK: - setUpPadding
    func setUpPadding(){
        emailPhoneTxt.setLeftPaddingPoints(10)
        emailPhoneTxt.setRightPaddingPoints(10)
        passwordTxt.setLeftPaddingPoints(10)
        passwordTxt.setRightPaddingPoints(10)
    }
    // MARK: - setUpPlaceHolder
    func setUpPlaceHolder(text : String){
        emailPhoneTxt.attributedPlaceholder = NSAttributedString(string: text,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Enter Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    // MARK: - setupSegmentedControl
    func setupSegmentedControl(){
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segment.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
    }
    // MARK: - validateLogin
    func validateLogin(){
        guard let email = emailPhoneTxt.text , let password = passwordTxt.text else {return}
        if(email.isEmpty == true || password.isEmpty == true){
            print("Please fill empty fields")
        } else {
            getLogin(email: email, password: password)
        }
    }
    // MARK: - getLogin with email
    func getLogin( email : String , password : String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if(error == nil){
                let vc = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
                vc.modalPresentationStyle = .fullScreen
                vc.typeofAuth = "\( self.typeOfUserInput )"
                self.present(vc, animated: true, completion: nil)
            } else {
                print("Wrong username or password")
            }
        }
    }
    // MARK: - IBAction
    @IBAction func segmentActionPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            setUpPlaceHolder(text: " Enter Email")
            self.codeButton.isHidden = true
            self.emailPhoneTxt.keyboardType = .emailAddress
            self.emailPhoneTxt.text = ""
        } else {
            setUpPlaceHolder(text: " Enter Phone")
            self.emailPhoneTxt.keyboardType = .numberPad
            self.codeButton.isHidden = false
            self.emailPhoneTxt.text = ""
        }
        self.emailPhoneTxt.resignFirstResponder()
        self.typeOfUserInput = TypeOfUserInput(rawValue: sender.selectedSegmentIndex) ?? .email
    }
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "RegisterVC") as! RegisterVC
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        validateLogin()
    }
    @IBAction func faceBookLoginButtonPressed(_ sender: Any) {
        let loginManger = LoginManager()
        loginManger.logIn(permissions: [.publicProfile , .email], viewController: self) { (result) in
            switch result{
            case .success(let granted, let declined, let token):
                print("Success Login in with FaceBook")
                self.firebaseFaceBookLogin(token: token)
            case .cancelled:
                print("cancelled")
            case .failed(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    @IBAction func googleLoginButtonPressed(_ sender: Any) {
    }
    
    @IBAction func appleLoginButtonPressed(_ sender: Any) {
    }
}
extension LoginVC  {
    // MARK: - firebaseFaceBookLogin
    fileprivate func firebaseFaceBookLogin(token :AccessToken ){
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
            }
            print("Success Login in with FireBase")
            print(user ?? "")
            if let userlogin = Auth.auth().currentUser {
                print("Current firebase user is")
                print(userlogin)
            }
        }
    }
}
