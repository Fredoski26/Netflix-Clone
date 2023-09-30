//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Fredrick on 28/08/2023.
//

import UIKit


enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies","Trending Tv","Popular","Upcoming Movies","Top rated"]
    
   
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)

        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNabar()
        
         headerView = HeroHeaderUIView(frame: CGRect(x: 0, y:0, width: view.bounds.width, height: 450))
    
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        
        //        Initialized black colour 
        homeFeedTable.backgroundColor = UIColor.black
        
       // navigationController?.pushViewController(TitlePreviewViewController(), animated: true)
        // Do any additional setup after loading the view.
        //fetchData()
    }
    
    private func configureHeroHeaderView(){
        ApiCaller.shared.getTrendingMovie{[weak self] result in switch result {
        case.success(let titles):
            let selectedTitle = titles.randomElement()
            self?.randomTrendingMovie = selectedTitle
            self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
        case.failure(let error):
            print(error.localizedDescription)
        }}
    }
    
    private func configureNabar(){
//        var image = UIImage(named: "Netflix2")
//        image = image?.withRenderingMode(.alwaysOriginal)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
       
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:UIImage(systemName: ""), style: .done, target: self,action: nil),
            UIBarButtonItem(image:UIImage(systemName: "play.rectangle"), style: .done, target: self,action: nil)
        ]
        navigationController?.navigationBar.tintColor = .systemBlue
        
        
        
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        
    }
    
   
    
//    private func fetchData(){
//        ApiCaller.shared.getTrendingMovie{results in switch results{
//        case.success(let movies):
//            print(movies)
//        case.failure(let error):
//            print(error)
//        }}
//
//        ApiCaller.shared.getTrendingTvs{results in switch results{
//        case.success(let tv):
//            print(tv)
//        case.failure(let error):
//            print(error)
//        }}
//
//
//        ApiCaller.shared.getMovieUpcoming{results in switch results{
//        case.success(let upcoming):
//            print(upcoming)
//        case.failure(let error):
//            print(error)
//        }}
//
//
//        ApiCaller.shared.getMoviePopular{results in switch results{
//        case.success(let popular):
//            print(popular)
//        case.failure(let error):
//            print(error)
//        }}
//
//
//
//
//        ApiCaller.shared.getMovieTopRated{results in switch results{
//        case.success(let toprated):
//            print(toprated)
//        case.failure(let error):
//            print(error)
//        }}
//    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            
            return UITableViewCell()
            
        }
        
        cell.delegate = self
        
        
        switch indexPath.section{
        case Sections.TrendingMovies.rawValue:
            ApiCaller.shared.getTrendingMovie{results in switch results{
            case.success(let title):
                cell.configure(with: title)
            case.failure(let error):
                print(error.localizedDescription)
                
            }}
            
        case Sections.TrendingTv.rawValue:
            ApiCaller.shared.getTrendingTvs{results in switch results{
            case.success(let title):
                cell.configure(with: title)
            case.failure(let error):
                print(error.localizedDescription)
                
            }}
            
        case Sections.Popular.rawValue:
            ApiCaller.shared.getMoviePopular{results in switch results{
            case.success(let title):
                cell.configure(with: title)
            case.failure(let error):
                print(error.localizedDescription)
                
            }}
            
            
            
        case Sections.Upcoming.rawValue:
            ApiCaller.shared.getMovieUpcoming{results in switch results{
            case.success(let title):
                cell.configure(with: title)
            case.failure(let error):
                print(error.localizedDescription)
                
            }}
            
            
            
            
        case Sections.TopRated.rawValue:
            ApiCaller.shared.getMovieTopRated{results in switch results{
            case.success(let title):
                cell.configure(with: title)
            case.failure(let error):
                print(error.localizedDescription)
                
            }}
        
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizationfilter()
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let Offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -Offset))
    }
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

//extension UIImage {
//    func resizeTo(size: CGSize) -> UIImage {
//        
//        
//        let renderer = UIGraphicsImageRenderer(size: size)
//        let image = renderer.image { _ in
//            self.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
//        }
//        
//        return image.withRenderingMode(self.renderingMode)
//    }
//}
