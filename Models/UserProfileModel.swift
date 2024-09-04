//
//  UserProfileModel.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 23/08/24.
//

import Foundation

struct UserProfileModel
{
    let username: String
    let email: String
    let password: String
    let Date: String
    let Time: String
}


struct LoginModel
{
    let email: String
    let password: String
}


// MARK: - Response Structure
struct LoginResponse: Codable {
    let data: UserData
    let status: String
    let message: String
}

// MARK: - User Data Structure
struct UserData: Codable {
    let id: String
    let username: String
    let email: String
    let type: String

    // Coding keys to map the JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case username
        case email
        case type
    }
}
