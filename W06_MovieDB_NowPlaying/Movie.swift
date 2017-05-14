//
//  Movie.swift
//  W06_MovieDB_NowPlaying
//
//  Created by Cntt16 on 5/13/17.
//  Copyright © 2017 Cntt16. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    var id: Int?
    var title: String?
    var poster: String?
    var overview: String?
    var releaseDate: String?
    var image: UIImage?

    init(id: Int?, title: String?, poster: String?, overview: String?, releaseDate: String?, image: UIImage?) {
        self.id = id
        self.title = title
        self .poster = poster
        self.overview = overview
        self.releaseDate = releaseDate
        self.image = image
    }
}
