//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Fredrick on 06/09/2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
   

 static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    public var title: [Title] = [Title]()
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
        width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.backgroundColor = UIColor.black
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //        Initialized black colour 
        collectionView.backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with title: [Title]){
        self.title = title
        DispatchQueue.main.sync {[weak self]in
            self?.collectionView.reloadData()
            
        }
    }
    
    public func downloadTitleAt(indexPath: IndexPath){
        DatapersistenceManager.share.downloadTitlewith(model: title[indexPath.row] ){ result in switch
            result {
            case.success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded") ,object: nil)
                print("download to database")
                
            case.failure(let error):
                print(error.localizedDescription)
            }}
    }
   
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //        cell.backgroundColor = .green
        //        return cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for:  indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = title[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return title.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let titles = title[indexPath.row]
        guard let titleName = titles.original_title ?? titles.original_name else {
            return
        }
        ApiCaller.shared.getMovie(with: titleName + "trailers") { [weak self] result in switch result {
        case.success(let videoElement):
            let titles = self?.title[indexPath.row]
            guard let titleOverview = titles?.overview else {
                return
            }
            guard let strongSelf = self else{
                return
            }
            let viewModel = TitlePreviewViewModel(title: titleName, youubeview: videoElement, titleOverview: titleOverview)
            self?.delegate?.collectionViewTableViewDidTapCell(strongSelf, viewModel: viewModel)
            // print(videoElement.id)
            
        case.failure(let error):
            print(error.localizedDescription)
            
        }
            
        }
        
    }
    
    
    //    Action for pop up download
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil )
        {[weak self] _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off)
            { _ in  print("Press me")
                self?.downloadTitleAt(indexPath: indexPaths[0] )  }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        
        return config
    }
    
    
    
    
//    private func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        
//        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil )
//        {[weak self] _ in
//            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off)
//            { _ in  print("Press me")
//                self?.downloadTitleAt(indexPath: IndexPath)  }
//            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
//        }
//       
//        
//        return config
//    }

}

