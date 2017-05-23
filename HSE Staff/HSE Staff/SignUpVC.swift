//
//  SignUpVC.swift
//  HSE Staff
//
//  Created by Ruziev on 5/23/17.
//  Copyright © 2017 Ruziev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftHash

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func onSignUp(_ sender: UIButton) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let rePassword = repeatPasswordTextField.text!
        
        if !username.isEmpty && !password.isEmpty && password == rePassword {
            Alamofire.request("http://127.0.0.1:5000/user/create?name=\(username)&passwordHash=\(MD5(password))")
            .authenticate(user: "admin", password: "admin")
            .response { response in
                if response.response?.statusCode == 200 {
                    let alertView = UIAlertView();
                    alertView.addButton(withTitle: "OK")
                    alertView.title = "Sign Up"
                    alertView.message = "New user \(username) created!"
                    alertView.show()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
