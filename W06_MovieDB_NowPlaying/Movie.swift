//
//  Movie.swift
//  W06_MovieDB_NowPlaying
//
//  Created by Cntt16 on 5/13/17.
//  Copyright © 2017 Cntt16. All rights reserved.
//

import Foundation

class Movie {
    var title: String?
    var poster: String?
    var overview: String?
    var releaseDate: String?

    init(title: String?, poster: String?, overview: String?, releaseDate: String?) {
        self.title = title
        self .poster = poster
        self.overview = overview
        self.releaseDate = releaseDate
    }
}
