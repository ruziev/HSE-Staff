//
//  EditProfileViewController.swift
//  HSE Staff
//
//  Created by Ruziev on 5/23/17.
//  Copyright © 2017 Ruziev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftHash

class EditProfileViewController: UIViewController {
    var currentLogin = ""
    var currentPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rePassword: UITextField!
    
    @IBAction func onSaveChanges(_ sender: UIButton) {
        let newLogin = login.text!
        let newPassword = password.text!
        let newRePassword = rePassword.text!
        
        var url = "http://127.0.0.1:5000/user/update?"
        
        if !newLogin.isEmpty {
            url = url + "newName=\(newLogin)&"
        }
        if !newPassword.isEmpty && newPassword == newRePassword {
            url = url + "newPasswordHash=\(MD5(newPassword))"
        }
        
        Alamofire.request(url)
        .authenticate(user: currentLogin, password: currentPassword)
            .response { response in
                if response.response?.statusCode == 200 {
                    let alert = UIAlertView()
                    alert.addButton(withTitle: "OK")
                    alert.title = "Пользователь"
                    alert.message = "Изменения сохранены"
                    alert.show()
                    self.navigationController?.popToRootViewController(animated: true)
                }
        }
        
    }
    
    @IBAction func onBackBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDelete(_ sender: UIButton) {
        Alamofire.request("http://127.0.0.1:5000/user/delete?sure=DEADSURE")
            .authenticate(user: currentLogin, password: currentPassword)
            .response { response in
                if response.response?.statusCode == 200 {
                    let alert = UIAlertView()
                    alert.addButton(withTitle: "OK")
                    alert.title = "Пользователь"
                    alert.message = "Пользователь удален"
                    alert.show()
                    self.navigationController?.popToRootViewController(animated: true)
                }
        }
    }
    
    
}
