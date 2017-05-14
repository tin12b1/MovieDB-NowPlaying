//
//  MovieDetailViewController.swift
//  W06_MovieDB_NowPlaying
//
//  Created by Tran Van Tin on 5/14/17.
//  Copyright © 2017 Cntt16. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                            self.lblReleaseDate.text = detail["release_date"]! as? String
                            let vote = detail["vote_average"] as? Double
                            self.lblVote.text = String(format: "%.1f", vote!)
                            let budget = detail["budget"]! as? Int
                            self.lblBudget.text = String(budget!)
                            let revenue = detail["revenue"]! as? Int
                            self.lblRevenue.text = String(revenue!)
                            self.lblOverview.text = detail["overview"]! as? String
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }).resume()
        }
    }
}
