//
//  PersonPageVC.swift
//  HSE Staff
//
//  Created by Ruziev on 5/22/17.
//  Copyright © 2017 Ruziev. All rights reserved.
//

import UIKit
import Alamofire

class PersonPageVC: UIViewController {

    var login = "", password = ""
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    var isAuthorized = false
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var phone: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editBarButton.isEnabled = isAuthorized
        
        if let url = person?.photo {
            Alamofire.request(url).response { response in
                if let data = response.data {
                    self.imageView.image = UIImage(data: data, scale: 1)
                }
            }
        }
        
        nameLabel.text = person?.name
        pageLink.text = person?.page
        if let personPhone = person?.phone {
            phone.text = "Телефон: \(personPhone)"
        } else {
            phone.text = "Нет номера телефона"
        }
        if let personEmail = person?.email {
            email.text = "Почта: \(personEmail)"
        } else {
            email.text = "Нет почты"
        }
        if let personAddress = person?.address {
            address.text = "Адрес: \(personAddress)"
        } else {
            address.text = "Нет адреса"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    var person: Person?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageLink: UITextView!
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    @IBAction func onNavigateBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromStaffToEditStaff" {
            let destination = segue.destination as! EditStaffViewController
            destination.staffId = (person?.id)!
            destination.login = login
            destination.password = password
        }
    }
}
