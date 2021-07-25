//
//  LoginVC.swift
//  DemoFirebaseAuth
//
//  Created by ahmed gado on 5/12/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//
import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import ADCountryPicker
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
    var code =  "+966"
    var verificationID = ""
    enum TypeOfUserInput: Int {
        case email
        case phone
    }
    var typeOfUserInput: TypeOfUserInput  = .email
    let appleProvider = AppleSignInClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
    }
    // MARK: - setUpView
    fileprivate func setUpView(){
        setUpCornerRadious()
        setUpPadding()
        setUpPlaceHolder(text: " Enter Email", textPass: "Enter Password")
        setupSegmentedControl()
        setUpborderColor()
        setUpborderWidth()
        hideKeyboardWhenTappedAround()
    }
    // MARK: - setUpborderColor
    fileprivate func setUpborderColor(){
        emailPhoneTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        passwordTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        codeButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    // MARK: - setUpborderWidth
    fileprivate func setUpborderWidth(){
        emailPhoneTxt.layer.borderWidth = 0.4
        passwordTxt.layer.borderWidth = 0.4
        codeButton.layer.borderWidth = 0.4
    }
    // MARK: - setUpCornerRadious
    fileprivate func setUpCornerRadious(){
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        emailPhoneTxt.layer.cornerRadius = emailPhoneTxt.frame.height / 2
        passwordTxt.layer.cornerRadius = passwordTxt.frame.height / 2
        codeButton.layer.cornerRadius = codeButton.frame.height / 2
        faceBookLoginButton.layer.cornerRadius = faceBookLoginButton.frame.height / 2
        googleLoginButton.layer.cornerRadius = googleLoginButton.frame.height / 2
        appleLoginButton.layer.cornerRadius = appleLoginButton.frame.height / 2
    }
    // MARK: - setUpPadding
    fileprivate func setUpPadding(){
        emailPhoneTxt.setLeftPaddingPoints(10)
        emailPhoneTxt.setRightPaddingPoints(10)
        passwordTxt.setLeftPaddingPoints(10)
        passwordTxt.setRightPaddingPoints(10)
    }
    // MARK: - setUpPlaceHolder
    fileprivate func setUpPlaceHolder(text : String , textPass : String  ){
        emailPhoneTxt.attributedPlaceholder = NSAttributedString(string: text,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: textPass,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    // MARK: - setupSegmentedControl
    fileprivate func setupSegmentedControl(){
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segment.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        
    }
    // MARK: - IBAction segmentActionPressed
    @IBAction func segmentActionPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            setUpPlaceHolder(text: " Enter Email", textPass: "Enter Password")
            self.codeButton.isHidden = true
            self.emailPhoneTxt.keyboardType = .emailAddress
            self.emailPhoneTxt.text = ""
            self.passwordTxt.isSecureTextEntry = true
            self.passwordTxt.isHidden = false
        } else {
            setUpPlaceHolder(text: " Enter Phone", textPass: "Enter verificationID")
            self.emailPhoneTxt.keyboardType = .numberPad
            self.codeButton.isHidden = false
            self.emailPhoneTxt.text = ""
            self.passwordTxt.isHidden = true
            self.passwordTxt.isSecureTextEntry = false
            self.passwordTxt.keyboardType = .numbersAndPunctuation
        }
        self.emailPhoneTxt.resignFirstResponder()
        self.typeOfUserInput = TypeOfUserInput(rawValue: sender.selectedSegmentIndex) ?? .email
        
    }
    // MARK: - IBAction createAccountButtonPressed
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "RegisterVC") as! RegisterVC
        self.present(vc, animated: true, completion: nil)
    }
    // MARK: - IBAction openCountriesPicker
    @IBAction func openCountriesPicker(_ sender: Any) {
        let picker = ADCountryPicker()
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        picker.delegate = self
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    // MARK: - IBAction loginButtonPressed
    @IBAction func loginButtonPressed(_ sender: Any) {
        switch typeOfUserInput {
        case .email:
            validateLogin()
        case .phone:
            validatePhone()
        @unknown default:
            break
        }
        
    }
    // MARK: - IBAction faceBookLoginButtonPressed
    @IBAction func faceBookLoginButtonPressed(_ sender: Any) {
        let loginManger = LoginManager()
        loginManger.logIn(permissions: [.publicProfile , .email], viewController: self) { (result) in
            switch result{
            case .success( _, _, let token):
                print("Success Login in with FaceBook")
                
                self.firebaseFaceBookLogin(token: token!)
            case .cancelled:
                print("cancelled")
            case .failed(let error):
                print(error.localizedDescription)
            }
        }
    }
    // MARK: - IBAction googleLoginButtonPressed
    @IBAction func googleLoginButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    // MARK: - IBAction appleLoginButtonPressed
    @IBAction func appleLoginButtonPressed(_ sender: Any) {
        appleProvider.handleAppleIdRequest(block: { fullName, email, token in
            // receive data in login class.
            let credentials = OAuthProvider.credential(withProviderID: "apple.com", idToken: token ?? "", rawNonce: "")
            self.firebaseLogin(credential: credentials)
        })
    }
}
extension LoginVC  {
    // MARK: - validateLogin
    fileprivate func validateLogin(){
        guard let email = emailPhoneTxt.text , let password = passwordTxt.text else {return}
        if(email.isEmpty == true || password.isEmpty == true){
            print("Please fill empty fields")
        } else {
            getLogin(email: email, password: password)
        }
    }
    // MARK: - getLogin with email
    fileprivate func getLogin( email : String , password : String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if(error == nil){
                self.goWelocomePage()
            } else {
                print("Wrong username or password")
            }
        }
    }
    // MARK: - validateLogin
    fileprivate func validatePhone(){
        guard let phone = emailPhoneTxt.text else {return}
        if phone.isEmpty == true{
            print("Please fill empty fields")
        } else {
            if passwordTxt.isHidden {
                getPhoneVerification(phone: phone)
            }
            else {
                let credential =  PhoneAuthProvider.provider().credential(withVerificationID: verificationID , verificationCode: passwordTxt.text ?? "")
                self.firebaseLogin(credential: credential)
                
            }
            
        }
    }
    // MARK: - getPhoneVerification
    fileprivate func getPhoneVerification(phone: String){
        PhoneAuthProvider.provider().verifyPhoneNumber(code + phone, uiDelegate: nil) { (verificationID, error) in
            
            if error != nil{
                
                print(error!.localizedDescription)
                return
            }
            print(verificationID ?? "")
            self.verificationID = verificationID ?? ""
            self.passwordTxt.isHidden = false
            
        }
        
    }
    // MARK: - goWelocomePage
    fileprivate func goWelocomePage() {
        let vc = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        vc.typeofAuth = "\( self.typeOfUserInput )"
        self.present(vc, animated: true, completion: nil)
    }
    // MARK: - firebaseLogin
    fileprivate func firebaseLogin(credential : AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("FireBaseLoginError", error)
                
            }
            print("Success Login in with FireBase")
            self.goWelocomePage()
            print(user ?? "")
            if let userlogin = Auth.auth().currentUser {
                print("Current firebase user is")
                print(userlogin)
            }
        }
        
    }
    // MARK: - firebaseFaceBookLogin
    fileprivate func firebaseFaceBookLogin(token :AccessToken ){
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        firebaseLogin(credential: credential)
    }
}
// MARK: -  GIDSignInDelegate
extension LoginVC :GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard  let user = user  else {return}
        print(user.profile.email ?? "")
        let credentials = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        firebaseLogin(credential: credentials)
        
    }
}
// MARK: -  ADCountryPickerDelegate
extension LoginVC : ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        self.code = dialCode
        codeButton.setTitle(dialCode, for: .normal)
        dismiss(animated: false, completion: nil)
    }
}

