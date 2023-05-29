//
//  ViewController3.swift
//  BibbleApp
//
//  Created by Валентин Казанцев on 29.05.2023.
//

import UIKit
import CoreData

class FavoriteBiblesViewController: UIViewController {
    private var tableView: UITableView!
    private var bibles: [Bibble] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadSavedBibles()
    }
    
    //при разворачивании экрана - обновляется бд локальная
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedBibles()
    }
    
    internal func deleteSavedBible(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let bibleEntity = convertToBibleEntity(bibles[indexPath.row], managedContext: managedContext)
        
        managedContext.perform {
            managedContext.delete(bibleEntity!)
            
            do {
                try managedContext.save()
                
                DispatchQueue.main.async {
                    self.bibles.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch {
                print("Failed to delete Bible: \(error)")
            }
        }
    }



}

extension Bibble {
    //тут, потому что модель не должна трогать кордату
    func toBibleEntity(managedContext: NSManagedObjectContext) -> BibleEntity {
        let entity = BibleEntity(context: managedContext)
        entity.id = id
        entity.language = language?.name
        entity.country = countries?.first?.name
        entity.name = name
        entity.nameLocal = nameLocal
        entity.descriptionText = description
        entity.descriptionLocal = descriptionLocal
        return entity
    }
}

extension FavoriteBiblesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bibles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BibleCell", for: indexPath) as! BibleTableViewCell
        let bible = bibles[indexPath.row]
        cell.configure(with: bible)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSavedBible(at: indexPath)
        }
    }
}


class BibleTableViewCell: UITableViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let translatedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let translatedDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//настройка интерфейса вк
extension FavoriteBiblesViewController {
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BibleTableViewCell.self, forCellReuseIdentifier: "BibleCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//настройка интерфейса ячейки
extension BibleTableViewCell {
    private func setupUI() {
        addSubview(nameLabel)
        addSubview(translatedNameLabel)
        addSubview(descriptionLabel)
        addSubview(translatedDescriptionLabel)
        addSubview(languageLabel)
        addSubview(countryLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            translatedNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            translatedNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            translatedNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: translatedNameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            translatedDescriptionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            translatedDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            translatedDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            languageLabel.topAnchor.constraint(equalTo: translatedDescriptionLabel.bottomAnchor, constant: 16),
            languageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            languageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            countryLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 8),
            countryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            countryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            countryLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with bible: Bibble) {
        nameLabel.text = bible.name
        translatedNameLabel.text = bible.nameLocal
        descriptionLabel.text = bible.description
        translatedDescriptionLabel.text = bible.descriptionLocal
        languageLabel.text = bible.language?.name
        countryLabel.text = bible.countries?.first?.name
    }
}


//coredata
extension FavoriteBiblesViewController {
    private func loadSavedBibles() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BibleEntity> = BibleEntity.fetchRequest()

        do {
            let results = try managedContext.fetch(fetchRequest)
            bibles = results.compactMap { convertToBible($0) }
            tableView.reloadData()
        } catch {
            print("Failed to fetch Bibles: \(error)")
        }
    }
    
    private func convertToBible(_ bibleEntity: BibleEntity) -> Bibble? {
        guard let id = bibleEntity.id,
              let languageName = bibleEntity.language,
              let countryName = bibleEntity.country,
              let name = bibleEntity.name,
              let descriptionText = bibleEntity.descriptionText else {
            return nil
        }
        
        let language = Language(name: languageName, script: nil)
        let country = Country(id: nil, name: countryName, nameLocal: nil)
        
        return Bibble(
            id: id,
            language: language,
            countries: [country],
            name: name,
            nameLocal: bibleEntity.nameLocal,
            description: descriptionText,
            descriptionLocal: bibleEntity.descriptionLocal
        )
    }
    
    private func convertToBibleEntity(_ bible: Bibble, managedContext: NSManagedObjectContext) -> BibleEntity? {
        let fetchRequest: NSFetchRequest<BibleEntity> = BibleEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", bible.id!)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch BibleEntity: \(error)")
            return nil
        }
    }
}
