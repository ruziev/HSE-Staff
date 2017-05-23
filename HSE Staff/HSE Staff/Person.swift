//
//  Person.swift
//  HSE Staff
//
//  Created by Ruziev on 5/20/17.
//  Copyright © 2017 Ruziev. All rights reserved.
//

import Foundation

class Person
{
    var name: String
    var page: String
    var phone: String?
    var email: String?
    var photo: String?
    var address: String?
    var id: String
    
    init(id: String, name: String, page: String, phone: String, email: String, photo: String, address: String) {
        self.id = id
        self.name = name
        self.page = page
        if email != "" {
            self.email = email
        }
        if photo != "http://hse.ru" {
            self.photo = photo
        }
        if phone != "" {
            self.phone = phone
        }
        if address != "" {
            self.address = address
        }
    }
}
