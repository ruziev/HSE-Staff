//
//  ViewController.swift
//  HSE Staff
//
//  Created by Ruziev on 5/19/17.
//  Copyright © 2017 Ruziev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    @IBOutlet weak var resultsTableView: UITableView!
    var login: String = ""
    var password: String = ""
    var isAuthorized = false
    
    @IBOutlet weak var newStaffButton: UIButton!
    
    func refreshData() {
        allData = []
        Alamofire.request("http://127.0.0.1:5000/allJSON")
            .authenticate(user: login, password: password)
            .response { response in
                if let data = response.data {
                    let persons = JSON(data: data).arrayValue
                    for person in persons {
                        let dict = person.dictionaryValue
                        let personObj = Person(
                            id: (dict["id"]?.stringValue)!,
                            name: (dict["name"]?.stringValue)!,
                            page: (dict["page"]?.stringValue)!,
                            phone: (dict["phone"]?.stringValue)!,
                            email: (dict["email"]?.stringValue)!,
                            photo: (dict["photo"]?.stringValue)!,
                            address: (dict["address"]?.stringValue)!)
                        self.allData.append(personObj)
                        self.searchResults = self.allData
                        self.resultsTableView.reloadData()
                    }
                }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newStaffButton.isEnabled = isAuthorized
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var allData: [Person] = []
    var searchResults: [Person] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row].name
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = []
        for person in allData {
            if person.name.lowercased().contains(searchText.lowercased()) {
                searchResults.append(person)
            }
        }
        resultsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPersonPage", sender: (searchResults[indexPath.row], isAuthorized))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPersonPage" {
            let sender = sender as! (Person,Bool)
            let destination = segue.destination as! PersonPageVC
            destination.person = sender.0
            destination.isAuthorized = sender.1
            destination.login = login
            destination.password = password
        }
        if segue.identifier == "fromListToSettings" {
            let destination = segue.destination as! EditProfileViewController
            destination.currentLogin = login
            destination.currentPassword = password
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
}

