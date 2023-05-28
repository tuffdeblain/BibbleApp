//
//  ViewController.swift
//  BibbleApp
//
//  Created by Валентин Казанцев on 27.05.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UITableViewDelegate {
    let headers: HTTPHeaders = ["api-key": "dc78a4be6c4529e824a533fa68f7f77a"]
    var searchResult: Search?
    var filteredBibles: [Bibble]?
    var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        fetchBibles(url: URLS.url.rawValue, header: headers)
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BibleCell")
        tableView.dataSource = self
        tableView.delegate = self  
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Bibles"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }


    func fetchBibles(url: String, header: HTTPHeaders) {
        NetworkManager.shared.request(url: url, method: .get, headers: headers) { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let search = try decoder.decode(Search.self, from: data)
                        self?.searchResult = search
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
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


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBibles?.count ?? 0
        }
        return searchResult?.data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BibleCell", for: indexPath)
        let bible: Bibble
        if searchController.isActive && searchController.searchBar.text != "" {
            bible = filteredBibles?[indexPath.row] ?? Bibble()
        } else {
            bible = searchResult?.data?[indexPath.row] ?? Bibble()
        }
        cell.textLabel?.text = bible.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.item
        performSegue(withIdentifier: "bibbleSegue", sender: nil)
    }


    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredBibles = searchResult?.data?.filter { (bible: Bibble) -> Bool in
                return bible.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
        } else {
            filteredBibles = searchResult?.data
        }
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "bibbleSegue" {
                    let vc = segue.destination as! ViewController2
                    vc.bible = searchResult?.data?[index]
                }
    }
}
