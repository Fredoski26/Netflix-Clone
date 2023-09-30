//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by Fredrick on 26/09/2023.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject{
    func searchResultViewControllerDidTapItem (_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultViewControllerDelegate?
    
    public let searchResultViewControllerView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchResultViewControllerView)
        searchResultViewControllerView.delegate = self
        searchResultViewControllerView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultViewControllerView.frame = view.bounds
       
    }

}



extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for:  indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
       return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
         
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        ApiCaller.shared.getMovie(with: titleName ){[weak self] results in
            switch results {
            case.success(let videoElement):
                self?.delegate?.searchResultViewControllerDidTapItem(TitlePreviewViewModel(title: titleName, youubeview: videoElement, titleOverview: title.overview ?? ""))
              
        case.failure(let error):
            print(error.localizedDescription)
        }
            
        }
        
       
    }
   
}
