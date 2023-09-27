//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Fredrick on 28/08/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
  public var titles: [Title] = [Title]()
    
    private let DiscoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "search for a movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        
        view.addSubview(DiscoverTable)
        DiscoverTable.delegate = self
        DiscoverTable.dataSource = self
        navigationItem.searchController = searchController
       // navigationController?.navigationBar.tintColor = .white
       fetchDiscoverMovie()
        
        searchController.searchResultsUpdater = self
        // Do any additional setup after loading the view.
    }
    
    private func fetchDiscoverMovie(){
        ApiCaller.shared.getDiscoverMovies{[weak self]reults in switch reults{
        case.success(let titles):
            self?.titles = titles
            DispatchQueue.main.async {
                self?.DiscoverTable.reloadData()
            }
        case.failure(let error):
            print(error.localizedDescription)
        }}
        }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DiscoverTable.frame = view.bounds
    }
    
}

extension SearchViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "unknown"
//
//        return cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as?  TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let  model = TitleViewModel(titleName:  title.original_title ?? title.original_name ?? "Unknown title name", posterURL: title.poster_path ?? "" )
        cell.configure(with: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
   
}

extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }
        
        ApiCaller.shared.search(with: query){ result in DispatchQueue.main.async {
            switch result{
            case.success(let titles):
                resultsController.titles = titles
                resultsController.searchResultViewControllerView.reloadData()
            case.failure(let error):
                print(error.localizedDescription)
            }
        } }
    }
}
