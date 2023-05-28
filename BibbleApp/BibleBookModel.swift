//
//  BibleBookModel.swift
//  BibbleApp
//
//  Created by Валентин Казанцев on 28.05.2023.
//

import Foundation

// MARK: - Search
struct Book: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let id, bibleID, abbreviation, name: String?
    let nameLong: String?
    let chapters: [BookChapter]?

    enum CodingKeys: String, CodingKey {
        case id
        case bibleID = "bibleId"
        case abbreviation, name, nameLong, chapters
    }
}

// MARK: - Chapter
struct BookChapter: Codable {
    let id, bibleID, number, bookID: String?
    let reference: String?

    enum CodingKeys: String, CodingKey {
        case id
        case bibleID = "bibleId"
        case number
        case bookID = "bookId"
        case reference
    }
}
