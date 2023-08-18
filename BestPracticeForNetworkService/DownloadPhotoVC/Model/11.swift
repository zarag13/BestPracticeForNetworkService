//
//  11.swift
//  BestPracticeForNetworkService
//
//  Created by Kirill on 17.08.2023.
//

import Foundation

struct SearchResults : Codable {
    let total : Int
    let results : [UnsplashPhoto]
    
}
struct UnsplashPhoto: Codable {
    let width : Int
    let height : Int
    let urls : [URLKing.RawValue: String]
    
    enum URLKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

//https://unsplash.com/documentation#search-photos
//https://unsplash.com/oauth/applications/481990
