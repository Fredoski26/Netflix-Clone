//
//  TvsModel.swift
//  Netflix Clone
//
//  Created by Fredrick on 25/09/2023.
//

import Foundation

struct TrendingTvsResponse:Codable{
    let results: [Tvs]
}


struct Tvs: Codable{
    let id: Int
    let title: String?
    let original_language: String?
    let poster_path: String?
    let media_type: String?
    let overview: String?
    let popularity: Double
    let release_date: String?
    let vote_average: Double?
    let vote_count: Int?
    let adult: Bool
    let name:String?
    let original_name: String?
//    let origin_country: []?
    let original_sub:String?
    let first_air_date: String?
    let backdrop_path: String?
}
