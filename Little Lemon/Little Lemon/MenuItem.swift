//
//  MenuItem.swift
//  Little Lemon
//
//  Created by Mimi_Son on 01/12/24.
//


import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
}

struct MenuItem: Decodable {
    let title: String
    let image: String
    let price: String
    let description: String
}
