//  BibbleApp
//
//  Created by Валентин Казанцев on 27.05.2023.
//
import Foundation


struct Search: Codable {
    let data: [Bibble]?
}


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
    

    init(id: String? = nil,
         dblID: String? = nil,
         abbreviation: String? = nil,
         abbreviationLocal: String? = nil,
         language: Language? = nil,
         countries: [Country]? = nil,
         name: String? = nil,
         nameLocal: String? = nil,
         description: String? = nil,
         descriptionLocal: String? = nil,
         relatedDbl: String? = nil,
         type: String? = nil,
         updatedAt: String? = nil,
         audioBibles: [AudioBible]? = nil) {
        self.id = id
        self.dblID = dblID
        self.abbreviation = abbreviation
        self.abbreviationLocal = abbreviationLocal
        self.language = language
        self.countries = countries
        self.name = name
        self.nameLocal = nameLocal
        self.description = description
        self.descriptionLocal = descriptionLocal
        self.relatedDbl = relatedDbl
        self.type = type
        self.updatedAt = updatedAt
        self.audioBibles = audioBibles
    }
}



struct AudioBible: Codable {
    let id, name, nameLocal, description: String?
    let descriptionLocal: String?
}


struct Country: Codable {
    let id, name, nameLocal: String?
}


struct Language: Codable {
    let name, script: String?
}
