//
//  MovieDetailViewController.swift
//  W06_MovieDB_NowPlaying
//
//  Created by Tran Van Tin on 5/14/17.
//  Copyright © 2017 Cntt16. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    // Khai báo các label để hiển thị thông tin chi tiết của phim
    @IBOutlet var posterImg: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblReleaseDate: UILabel!
    @IBOutlet var lblVote: UILabel!
    @IBOutlet var lblBudget: UILabel!
    @IBOutlet var lblRevenue: UILabel!
    @IBOutlet var lblOverview: UILabel!

    var id: Int?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetail()
        title = "Movie Detail"
        posterImg.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Hàm lấy thông tin chi tiết phim từ trang The MovieDB
    func getMovieDetail() {
        if let movieId = id {
            let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(API)&language=en-US")
            var detail = [String:Any]()
            let request = NSMutableURLRequest(url: url! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
            request.httpMethod = "GET"
            _ = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (Data, URLResponse, Error) in
                if (Error != nil) {
                    print(Error!)
                } else {
                    do {
                        detail = try JSONSerialization.jsonObject(with: Data!, options: .allowFragments) as! [String:Any]
                        DispatchQueue.main.async {
                            self.lblTitle.text = detail["title"]! as? String
                            if let day = detail["release_date"] {
                                self.lblReleaseDate.text = "Release Date: \(day)"
                            }
                            if let vote = detail["vote_average"] {
                                self.lblVote.text = "⭐️ \(vote)"
                            }
                            if let budget = detail["budget"] {
                                self.lblBudget.text = "Budget: \(budget)$"
                            }
                            if let revenue = detail["revenue"] {
                                self.lblRevenue.text = "Revenue: \(revenue)$"
                            }
                            if let overview = detail["overview"] {
                                self.lblOverview.text = "Overview: \(overview)"
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }).resume()
        }
    }
}
