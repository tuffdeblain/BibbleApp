//
//  ViewController.swift
//  BibbleApp
//
//  Created by Валентин Казанцев on 27.05.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    let headers: HTTPHeaders = ["api-key": "b4a7bf98adb238d0a3a3b9a826060a4b"]
    var searchResult: Search?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchBibles(url: URLS.url.rawValue, header: headers)

    }


}

extension ViewController {
    func fetchBibles(url: String, header: HTTPHeaders) {
        NetworkManager.shared.request(url: url, method: .get, headers: headers) { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let search = try decoder.decode(Search.self, from: data)
                        self?.searchResult = search
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
