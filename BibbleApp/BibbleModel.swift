//  BibbleApp
//
//  Created by Валентин Казанцев on 27.05.2023.
//
import Foundation

// MARK: - Search
struct Search: Codable {
    let data: [Bibble]?
}

// MARK: - Datum
struct Bibble: Codable {
    let id, dblID, abbreviation, abbreviationLocal: String?
    let language: Language?
    let countries: [Country]?
    let name, nameLocal, description, descriptionLocal: String?
    let relatedDbl, type, updatedAt: String?
    let audioBibles: [AudioBible]?

    enum CodingKeys: String, CodingKey {
        case id
        case dblID = "dblId"
        case abbreviation, abbreviationLocal, language, countries, name, nameLocal, description, descriptionLocal, relatedDbl, type, updatedAt, audioBibles
    }
}

// MARK: - AudioBible
struct AudioBible: Codable {
    let id, name, nameLocal, description: String?
    let descriptionLocal: String?
}

// MARK: - Country
struct Country: Codable {
    let id, name, nameLocal: String?
}

// MARK: - Language
struct Language: Codable {
    let name, script: String?
}
