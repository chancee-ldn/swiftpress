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
    var postsOutputDirectory: String = ""
    var frontpage: Int = 1
}


struct Post {    
    var title: String
    var date: Date
    var link: String
    var body: String
    
    
    func ukDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let d = dateFormatter.string(from: date)
        return d
    }
    
    
    func guid() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        let guid = dateFormatter.string(from: date) + "-" + cleanTitle()
        return guid
    }
    
    // doesn't remove spaces, replaces characters with html entities
    func titleSafe() -> String {
        var c = title
        c = c.replacingOccurrences(of: ",", with: "")
        c = c.replacingOccurrences(of: "&", with: "&amp;")
        c = c.replacingOccurrences(of: "!", with: "")
        c = c.replacingOccurrences(of: ":", with: "")
        c = c.replacingOccurrences(of: "/", with: "-")
        
        return c
    }
    
    // strips everything to be a safe filename, lowercases, to be friendly
    func cleanTitle() -> String {
        var c = title
        c = c.replacingOccurrences(of: ",", with: "")
        c = c.replacingOccurrences(of: "&", with: "")
        c = c.replacingOccurrences(of: "'", with: "")
        c = c.replacingOccurrences(of: "!", with: "")
        c = c.replacingOccurrences(of: ":", with: "")
        c = c.replacingOccurrences(of: " ", with: "-")
        c = c.replacingOccurrences(of: "/", with: "-")
        
        c = c.lowercased()
        return c
    }

}
