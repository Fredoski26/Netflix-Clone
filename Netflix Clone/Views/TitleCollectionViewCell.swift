//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Fredrick on 25/09/2023.
//

import UIKit
import SDWebImage
class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
   
    public func configure(with model: String){
       // print(model)
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {return}
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
    
//    public func configure2(with model2: String){
//       // print(model)
//        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model2)") else {return}
//        posterImageView.sd_setImage(with: url, completed: nil)
//    }
}
