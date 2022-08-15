//
//  Websites.swift
//  Project4
//
//  Created by Allan Amaral on 10/07/22.
//

struct Websites {
    static let whiteList = ["apple.com", "hackingwithswift.com"]
    
    static func whiteListContains(_ host: String) -> Bool {
        for website in Websites.whiteList {
            if host.contains(website) {
                return true
            }
        }
        return false
    }
}
