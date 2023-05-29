//
//  URLS.swift
//  BibbleApp
//
//  Created by Валентин Казанцев on 27.05.2023.
//

import Foundation

enum URLS: String {
    case mainUrl = "https://api.scripture.api.bible/v1/bibles?include-full-details=true"
    case apiKey = "ce4a52b38076b9ad1ad748d977d14d6b"
    case biblesUrl = "https://api.scripture.api.bible/v1/bibles/"
    case biblesPath = "/books/"
    case chaptersPath = "/books?include-chapters=true&include-chapters-and-sections=true"
}
