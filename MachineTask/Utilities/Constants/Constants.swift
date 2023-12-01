//
//  Constants.swift
//  MachineTask
//
//  Created by ADMIN on 01/12/23.
//

import Foundation

struct Constants {
    
    struct Storyboard {
        static let loginViewController = "LoginViewController"
        static let headlineVC = "HeadLineVC"
        
    }

    struct Auth {
        static let uppercaseLetters = CharacterSet.uppercaseLetters
        static let lowercaseLetters = CharacterSet.lowercaseLetters
        static let decimalDigits = CharacterSet.decimalDigits
        static let specialCharacters = CharacterSet(charactersIn: "$@$!%*?&")

        static let minimumPasswordLength = 8
    }

    struct Alert {
        static let title = "Alert"
        static let okButtonTitle = "OK"
    }

        struct API {
            static let newsAPIKey = "f6fabf7c984447d1aee940d0118832a3"
            static let newsAPIURL = "https://newsapi.org/v2/everything?q=tesla&from=2023-10-30&sortBy=publishedAt&apiKey=\(newsAPIKey)"
        }

        struct TableView {
            static let headlineCellIdentifier = "HeadLineScreenTVC"
            static let estimatedRowHeight = 100.0
        }

        struct DateFormat {
            static let iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
            static let display = "yyyy-MM-d"
        }

        struct ImagePlaceholder {
            static let invalidDate = "Invalid Date"
        }
}
