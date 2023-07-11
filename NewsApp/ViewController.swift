//
//  ViewController.swift
//  NewsApp
//
//  Created by Deep Chaturvedi on 5/18/22.
//

import UIKit
import SafariServices
//TableView
//CustomCell
//API Caller
//Open the News Story
// Serach for the News Stories

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(NewTableViewCell.self, forCellReuseIdentifier:NewTableViewCell.identifier)
        return table
    }()
    
    private var viewModel = [NewTableViewCellViewModel]()
    private var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "India Today"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
        navigationController?.navigationBar.backgroundColor = UIColor.red
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        APICcaller.shared.getToStories { result in
            switch result{
            case.success(let articles):
                self.articles = articles
                self.viewModel = articles.compactMap({NewTableViewCellViewModel(title: $0.title, subTitle:$0.description ?? "no description", image:  URL(string: $0.urlToImage ?? ""),publised: $0.publishedAt)})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTableViewCell.identifier ,for: indexPath) as? NewTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModel[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }


}

