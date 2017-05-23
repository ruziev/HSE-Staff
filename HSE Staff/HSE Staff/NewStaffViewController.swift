//
//  NewStaffViewController.swift
//  HSE Staff
//
//  Created by Ruziev on 5/23/17.
//  Copyright © 2017 Ruziev. All rights reserved.
//

import UIKit
import Alamofire

class NewStaffViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var pageLink: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var photo: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        if (name.text?.isEmpty)! || (pageLink.text?.isEmpty)! {
            let alert = UIAlertView()
            alert.addButton(withTitle: "OK")
            alert.title = "Eror"
            alert.message = "ФИО и ссылка на страницу должны быть заполнены"
            alert.show()
            return
        }
        let staffName = name.text!
        let escapedStaffName = staffName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let escapedStaffPhoto = photo.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let escapedStaffPhone = phone.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let escapedStaffAddress = address.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let escapedStaffPage = pageLink.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let escapedMail = email.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let url = "http://127.0.0.1:5000/staff/create?name=\(escapedStaffName)&photo=\(escapedStaffPhoto)&phone=\(escapedStaffPhone)&address=\(escapedStaffAddress)&page=\(escapedStaffPage)&email=\(escapedMail)"
        print(url)
        Alamofire.request(url).response { response in
            if response.response?.statusCode == 200 {
                let alert = UIAlertView()
                alert.addButton(withTitle: "OK")
                alert.title = "Новый сотрудник"
                alert.message = "Сотрудник \(staffName) добавлен"
                alert.show()
                
                let stack = (self.navigationController?.viewControllers)!
                let previousVC = stack[stack.count-2] as! ViewController
                print(previousVC)
                previousVC.refreshData()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func onImagePreview(_ sender: UIButton) {
        let link = photo.text!
        print(link)
        Alamofire.request(link).response { response in
            if let data = response.data {
                print(data)
                self.imagePreview.image = UIImage(data: data, scale: 1)
                
            }
        }
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}
