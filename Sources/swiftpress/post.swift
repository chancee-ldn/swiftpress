//
//  post.swift
//  swiftpress
//
//  Created by chancee on 22/10/2019.
//

import Foundation
//import Ink



struct Config {
    var url: String = ""
    var outputDirectory: String = ""
    var templateDirectory: String = ""
    var postsDirectory: String = ""
    var frontpage: Int = 1
}


struct Post {    
    var title: String
    var date: Date
    var link: String
    var body: String
    
    
    func ukDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss z"
        let d = dateFormatter.date(from: date.description)
        return d!
    }
    
    
    func guid() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        let guid = dateFormatter.string(from: date) + "-" + friendlyURL()
        return guid
    }
    
    
    
    func friendlyURL() -> String {
        var c = title
        c = c.replacingOccurrences(of: ",", with: "")
        c = c.replacingOccurrences(of: "&", with: "&")
        c = c.replacingOccurrences(of: " ", with: "-")
        c = c.replacingOccurrences(of: "!", with: "")
        c = c.replacingOccurrences(of: ":", with: "")
        c = c.replacingOccurrences(of: "/", with: "-")
        
        c = c.lowercased()
        return c
    }

}
