//
//  ViewController.swift
//  BibbleApp
//
//  Created by Валентин Казанцев on 27.05.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource {
    let headers: HTTPHeaders = ["api-key": "b4a7bf98adb238d0a3a3b9a826060a4b"]
    var searchResult: Search?
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchBibles(url: URLS.url.rawValue, header: headers)
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BibleCell")
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
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
        return searchResult?.data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BibleCell", for: indexPath)
        if let bibleName = searchResult?.data?[indexPath.row].name {
            cell.textLabel?.text = bibleName
        }
        return cell
    }
}
