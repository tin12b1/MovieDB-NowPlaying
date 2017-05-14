//
//  MovieDetail.swift
//  W06_MovieDB_NowPlaying
//
//  Created by Tran Van Tin on 5/14/17.
//  Copyright © 2017 Cntt16. All rights reserved.
//

import Foundation

class MovieDetail {
    var title: String?
    var overview: String?
    var releaseDate: String?
    var vote: Double?
    var budget: Int?
    var revenue: Int?
    
    init(title: String?, overview: String?, releaseDate: String?, vote: Double?, budget: Int?, revenue: Int?) {
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.vote = vote
        self.budget = budget
        self.revenue = revenue
    }
}
