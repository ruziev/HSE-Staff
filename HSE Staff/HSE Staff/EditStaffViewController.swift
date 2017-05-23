//
//  EditStaffViewController.swift
//  HSE Staff
//
//  Created by Ruziev on 5/24/17.
//  Copyright © 2017 Ruziev. All rights reserved.
//

import UIKit
import Alamofire

class EditStaffViewController: UIViewController {
    var staffId = ""
    var login = ""
    var password = ""
    @IBOutlet weak var pageLink: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var photo: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPreview(_ sender: UIButton) {
        let link = photo.text!
        print(link)
        Alamofire.request(link).response { response in
            if let data = response.data {
                print(data)
                self.imagePreview.image = UIImage(data: data, scale: 1)
                
            }
        }
    }
    
    @IBAction func onSaveBarButton(_ sender: UIBarButtonItem) {
        var url = "http://127.0.0.1:5000/staff/\(staffId)/update?"
        if !(name.text?.isEmpty)! {
            url = url + "name=\(name.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&"
        }
        if !(email.text?.isEmpty)! {
            url = url + "email=\(email.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&"
        }
        if !(phone.text?.isEmpty)! {
            url = url + "phone=\(phone.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&"
        }
        if !(address.text?.isEmpty)! {
            url = url + "address=\(address.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&"
        }
        if !(pageLink.text?.isEmpty)! {
            url = url + "page=\(pageLink.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&"
        }
        if !(photo.text?.isEmpty)! {
            url = url + "photo=\(photo.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        }
        print(url)
        Alamofire.request(url)
        .authenticate(user: login, password: password)
            .response { response in
                if response.response?.statusCode == 200 {
                    let alert = UIAlertView()
                    alert.addButton(withTitle: "OK")
                    alert.title = "Сотрудник"
                    alert.message = "Изменения сохранены"
                    alert.show()
                    
                    self.performSegue(withIdentifier: "fromEditStaffToList", sender: nil)
                }
            }
    }
    
    @IBAction func onDelete(_ sender: UIButton) {
        Alamofire.request("http://127.0.0.1:5000/staff/\(staffId)/delete?sure=DEADSURE")
            .authenticate(user: login, password: password)
            .response { response in
                if response.response?.statusCode == 200 {
                    let alert = UIAlertView()
                    alert.addButton(withTitle: "OK")
                    alert.title = "Сотрудник"
                    alert.message = "Сотрудник удален"
                    alert.show()
                    
                    self.performSegue(withIdentifier: "fromEditStaffToList", sender: nil)
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromEditStaffToList" {
            let destination = segue.destination as! ViewController
            destination.login = login
            destination.password = password
            destination.isAuthorized = true
        }
    }
    
    
    @IBAction func onBackBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}
