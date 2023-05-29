//
//  ViewController2.swift
//  BibbleApp
//
//  Created by Валентин Казанцев on 28.05.2023.
//

import UIKit
import Alamofire
import CoreData

class BookInfoViewController: UIViewController {
    var tableView: UITableView!
    var bookTitles: [String] = []

    var bible: Bibble?
    var fetchedBooks: Set<String> = []
    
    let headers: HTTPHeaders = ["api-key": URLS.apiKey.rawValue]

    let starButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let translatedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let translatedDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Chapters of this Book"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedBibbles()
        fetchBibleChapters(bibleID: bible?.id ?? "1")
      
        setupUI()
    }

    func setupUI() {
        guard let bible = bible else {
            return
        }
        
        view.addSubview(nameLabel)
        view.addSubview(translatedNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(translatedDescriptionLabel)
        view.addSubview(languageLabel)
        view.addSubview(countryLabel)
        view.addSubview(tableHeaderLabel)
        view.addSubview(starButton)

        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            translatedNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            translatedNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            translatedNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: translatedNameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            translatedDescriptionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            translatedDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            translatedDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            languageLabel.topAnchor.constraint(equalTo: translatedDescriptionLabel.bottomAnchor, constant: 16),
            languageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            languageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            countryLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 8),
            countryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            countryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            countryLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableHeaderLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 16),
            tableHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            starButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            starButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            starButton.widthAnchor.constraint(equalToConstant: 30),
            starButton.heightAnchor.constraint(equalTo: starButton.widthAnchor)


        ])
        
        nameLabel.text = bible.name
        translatedNameLabel.text = bible.nameLocal
        descriptionLabel.text = bible.description
        translatedDescriptionLabel.text = bible.descriptionLocal
        languageLabel.text = bible.language?.name
        countryLabel.text = bible.countries?.first?.name
        
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        
        setupTableView()
    }
    
    @objc func starButtonTapped() {

        saveBibbleIfNeeded(bibble: bible!)
    }
    
    func setupTableView() {
            tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: tableHeaderLabel.bottomAnchor, constant: 8),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    
    func fetchBibleChapters(bibleID: String) {
        guard let bibleId = bible else {
            return
        }
        let url = URLS.biblesUrl.rawValue + (bibleId.id ?? "17c44f6c89de00db-01") + URLS.chaptersPath.rawValue


        NetworkManager.shared.request(url: url, method: .get, headers: headers) { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let bibleChapters = try decoder.decode(BibleChapters.self, from: data)
                        
                        DispatchQueue.main.async {
                     
                            
                            guard let bibles = bibleChapters.data else {return}
                            for bible in bibles {
                                guard let chapters = bible.chapters else {return}
                                for chapter in chapters {
                                    self?.fetchBook(bibleID: chapter.bibleID ?? "", bookID: chapter.bookID ?? "")
                                }
                            }
                            
                        }
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    func fetchBook(bibleID: String, bookID: String) {
        let url = URLS.biblesUrl.rawValue + bibleID + URLS.biblesPath.rawValue + bookID

        NetworkManager.shared.request(url: url, method: .get, headers: headers) { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let book = try decoder.decode(Book.self, from: data)
                      
                        guard let bookID = book.data?.id else { return }
                        if self?.fetchedBooks.contains(bookID) == false {
                            self?.fetchedBooks.insert(bookID)
                            DispatchQueue.main.async {
                                if let bookName = book.data?.name {
                                    self?.bookTitles.append(bookName)
                                    self?.tableView.reloadData()
                                }
                            }
                        }
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}
//данные таблицы
extension BookInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return bookTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
        cell.textLabel?.text = bookTitles[indexPath.row]
        return cell
    }
}
//кордата
extension BookInfoViewController {
    private func saveBibbleIfNeeded(bibble: Bibble) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<BibleEntity> = BibleEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", bibble.id ?? "")

            do {
                let results = try managedContext.fetch(fetchRequest)

                if let existingBibleEntity = results.first {
                    existingBibleEntity.id = bibble.id
                    existingBibleEntity.name = bibble.name
                    existingBibleEntity.nameLocal = bibble.nameLocal
                    existingBibleEntity.country = bibble.countries?.first?.name
                    existingBibleEntity.descriptionLocal = bibble.descriptionLocal
                    existingBibleEntity.descriptionText = bibble.description
                    existingBibleEntity.language = bibble.language?.name
            
                    try managedContext.save()
                
                } else {
                    let newBibleEntity = BibleEntity(context: managedContext)
                    newBibleEntity.id = bibble.id
                    newBibleEntity.name = bibble.name
                    newBibleEntity.nameLocal = bibble.nameLocal
                    newBibleEntity.country = bibble.countries?.first?.name
                    newBibleEntity.descriptionLocal = bibble.descriptionLocal
                    newBibleEntity.descriptionText = bibble.description
                    newBibleEntity.language = bibble.language?.name
                    try managedContext.save()
                  
                }
            } catch {
                print("Failed to save Bible: \(error)")
            }
        }

        private func loadSavedBibbles() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<BibleEntity> = BibleEntity.fetchRequest()

            do {
                let results = try managedContext.fetch(fetchRequest)
                var bibles: [Bibble] = []

                       for bibleEntity in results {
                           let bible = Bibble(
                               id: bibleEntity.id,
                               language: Language(name: bibleEntity.language, script: nil),
                               countries: [Country(id: nil, name: bibleEntity.country, nameLocal: nil)],
                               name: bibleEntity.name,
                               nameLocal: bibleEntity.nameLocal,
                               description: bibleEntity.descriptionText,
                               descriptionLocal: bibleEntity.descriptionLocal
                           )

                           bibles.append(bible)
                       }
            } catch {
                print("Failed to fetch Bibles: \(error)")
            }
        }
}
