//
//  UpComingViewController.swift
//  Netflix Clone
//
//  Created by Fredrick on 28/08/2023.
//

import UIKit

class UpComingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        
//        let textAttributes: [NSAttributedString.Key: Any] = [
//                .foregroundColor: UIColor.white // Set the text color to white
//                // You can also set other attributes like font, shadow, etc. if needed
//            ]
//
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        fetchUpcomingData()
        upcomingTable.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

    
    
   private func fetchUpcomingData(){
        ApiCaller.shared.getMovieUpcoming{[weak self]reults in switch reults{
        case.success(let titles):
            self?.titles = titles
            DispatchQueue.main.async {
                self?.upcomingTable.reloadData()
            }
        case.failure(let error):
            print(error.localizedDescription)
        }}
    }
}

extension UpComingViewController:UITableViewDelegate, UITableViewDataSource{
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
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        ApiCaller.shared.getMovie(with: titleName){[weak self] results in
            switch results {
            case.success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                      vc.configure(with: TitlePreviewViewModel(title: titleName, youubeview: videoElement, titleOverview: title.overview ?? ""))
                      self?.navigationController?.pushViewController(vc, animated: true)
                }
              
        case.failure(let error):
            print(error.localizedDescription)
        }
            
        }
    }
}
