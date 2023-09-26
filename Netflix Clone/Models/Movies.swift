//
//  Movies.swift
//  Netflix Clone
//
//  Created by Fredrick on 23/09/2023.
//

import Foundation

//struct TrendingMovieResponse: Codable{
//    let results: [Movies]
//}
//
//struct Movies: Codable{
//
//        let id: Int
//        let title: String?
//        let original_language: String?
//        let original_title: String?
//        let poster_path: String?
//        let media_type: String?
//        let overview: String?
//        let popularity: Double
//        let release_date: String?
//        let vote_average: Double?
//        let vote_count: Int?
//        let video: Bool
//        let adult: Bool
//        let backdrop_path: String?
//}



struct TrendingTitleResponse: Codable{
    let results: [Title]
}

struct Title: Codable{

        let id: Int
        let title: String?
        let original_language: String?
        let original_title: String?
        let poster_path: String?
        let media_type: String?
        let overview: String?
        let popularity: Double
        let release_date: String?
        let vote_average: Double?
        let vote_count: Int?
        let video: Bool?
        let adult: Bool
        let name:String?
        let original_name: String?
        let first_air_date: String?
        let backdrop_path: String?
        
}
