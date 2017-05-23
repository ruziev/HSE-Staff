//
//  LoginVC.swift
//  HSE Staff
//
//  Created by Ruziev on 5/23/17.
//  Copyright © 2017 Ruziev. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func onSignIn(_ sender: UIButton) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        Alamofire.request("http://127.0.0.1:5000/staff/create")
        .authenticate(user: username, password: password)
        .response { response in
            if response.response?.statusCode == 400 {
                self.performSegue(withIdentifier: "fromLoginToList",
                             sender: (username, password, true))
            }
        }
    }
    @IBAction func onSkipLogin(_ sender: UIButton) {
        let username = "admin"
        let password = "admin"
        Alamofire.request("http://127.0.0.1:5000/staff/create")
            .authenticate(user: username, password: password)
            .response { response in
                if response.response?.statusCode == 400 {
                    self.performSegue(withIdentifier: "fromLoginToList",
                                      sender: (username, password, false))
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromLoginToList" {
            let destination = segue.destination as! ViewController
            let user = sender as! (String,String,Bool)
            destination.login = user.0
            destination.password = user.1
            destination.isAuthorized = user.2
        }
    }
}

