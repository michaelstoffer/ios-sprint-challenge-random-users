//
//  User.swift
//  Random Users
//
//  Created by Michael Stoffer on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Equatable, Decodable {
    enum Keys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        enum NameKeys: String, CodingKey {
            case first, last
        }
        
        enum ImageKeys: String, CodingKey {
            case large, thumbnail
        }
    }
    
    let name: String
    let phone: String
    let email: String
    let thumbnailImage: URL
    let largeImage: URL
    
    init(name: String, phone: String, email: String, thumbnailImage: URL, largeImage: URL) {
        self.name = name
        self.phone = phone
        self.email = email
        self.thumbnailImage = thumbnailImage
        self.largeImage = largeImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        
        let nameContainer = try container.nestedContainer(keyedBy: Keys.NameKeys.self, forKey: .name)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        self.name = "\(firstName.capitalized) \(lastName.capitalized)"
        
        let thumbImageContainer = try container.nestedContainer(keyedBy: Keys.ImageKeys.self, forKey: .picture)
        self.thumbnailImage = try thumbImageContainer.decode(URL.self, forKey: .thumbnail)

        let largeImageContainer = try container.nestedContainer(keyedBy: Keys.ImageKeys.self, forKey: .picture)
        self.largeImage = try largeImageContainer.decode(URL.self, forKey: .large)
    }
}

struct Users: Decodable {
    let results: [User]
    
    enum UserKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        self.results = try container.decode([User].self, forKey: .results)
    }
}
