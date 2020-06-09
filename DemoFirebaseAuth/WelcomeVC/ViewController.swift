//
//  ViewController.swift
//  DemoFirebaseAuth
//
//  Created by ahmed gado on 5/12/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var typeofAuth = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        print(typeofAuth)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(gotoLogin))
        view.addGestureRecognizer(tapGesture)
        
    }
    @objc func gotoLogin() {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
        let vc = storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginVC
        self.present(vc, animated: true, completion: nil)
    }
    
}

