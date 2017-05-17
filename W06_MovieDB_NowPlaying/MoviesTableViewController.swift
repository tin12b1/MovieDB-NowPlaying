//
//  MoviesTableViewController.swift
//  W06_MovieDB_NowPlaying
//
//  Created by Cntt16 on 5/13/17.
//  Copyright © 2017 Cntt16. All rights reserved.
//

import UIKit

// Class hỗ trợ tải hình ảnh từ một URL xác định
class Downloader {
    class func downloadImageWithURL(_ url:String) -> UIImage! {
        let data = try? Data(contentsOf: URL(string: url)!)
        return UIImage(data: data!)
    }
}

class MoviesTableViewController: UITableViewController {
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var movies = [Movie]()
    var queue = OperationQueue()
    var loadingData = false
    var refreshPage = 20
    var p = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovie(page: p)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // Đổ dữ liệu vào cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.imageView?.image = #imageLiteral(resourceName: "default")
        queue.addOperation { () -> Void in
            if let img = Downloader.downloadImageWithURL("\(prefixImg)\(self.movies[indexPath.row].poster!)") {
                OperationQueue.main.addOperation({
                    self.movies[indexPath.row].image = img
                    cell.imageView?.image = img
                })
            }
        }
        cell.textLabel?.text = movies[indexPath.row].title
        cell.detailTextLabel?.text = movies[indexPath.row].overview
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !loadingData && indexPath.row == refreshPage - 1 {
            spinner.startAnimating()
            loadingData = true
            loadMovie2(page: p)
        }
    }
    
    // Hàm gửi yêu cầu lên trang The MovieDB để lấy dữ liệu các bộ phim đang chiếu về (Now Playing Movies)
    func loadMovie(page:Int) {
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API)&language=en-US&page=\(page)")
        dataTask = defaultSession.dataTask(with: url! as URL) {
            data, response, error in
            
            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                            // Lấy các thông tin cần thiết từ mảng results được trang web trả về
                            if let array: AnyObject = response["results"] {
                                for movieDictonary in array as! [AnyObject] {
                                    if let movieDictonary = movieDictonary as? [String: AnyObject], let title = movieDictonary["title"] as? String {
                                        let movie_id = movieDictonary["id"] as? Int
                                        let poster = movieDictonary["poster_path"] as? String
                                        let overview = movieDictonary["overview"] as? String
                                        let releaseDate = movieDictonary["release_date"] as? String
                                        self.movies.append(Movie(id: movie_id, title: title, poster: poster, overview: overview, releaseDate: releaseDate, image: #imageLiteral(resourceName: "default")))
                                    } else {
                                        print("Not a dictionary")
                                    }
                                }
                                self.p += 1
                            } else {
                                print("Results key not found in dictionary")
                            }
                        } else {
                            print("JSON Error")
                        }
                    } catch let error as NSError {
                        print("Error parsing results: \(error.localizedDescription)")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    
                }
            }
        }
        
        dataTask?.resume()
    }
    
    func loadMovie2(page:Int) {
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API)&language=en-US&page=\(page)")
        dataTask = defaultSession.dataTask(with: url! as URL) {
            data, response, error in
            
            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                            // Lấy các thông tin cần thiết từ mảng results được trang web trả về
                            if let array: AnyObject = response["results"] {
                                for movieDictonary in array as! [AnyObject] {
                                    if let movieDictonary = movieDictonary as? [String: AnyObject], let title = movieDictonary["title"] as? String {
                                        let movie_id = movieDictonary["id"] as? Int
                                        let poster = movieDictonary["poster_path"] as? String
                                        let overview = movieDictonary["overview"] as? String
                                        let releaseDate = movieDictonary["release_date"] as? String
                                        self.movies.append(Movie(id: movie_id, title: title, poster: poster, overview: overview, releaseDate: releaseDate, image: #imageLiteral(resourceName: "default")))
                                    } else {
                                        print("Not a dictionary")
                                    }
                                }
                                self.refreshPage += 20
                                self.tableView.reloadData()
                                self.spinner.stopAnimating()
                                self.loadingData = false
                                self.p += 1
                            } else {
                                print("Results key not found in dictionary")
                            }
                        } else {
                            print("JSON Error")
                        }
                    } catch let error as NSError {
                        print("Error parsing results: \(error.localizedDescription)")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    
                }
            }
        }
        
        dataTask?.resume()
    }
    
    // MARK: - Navigation
    // Chuẩn bị các thông tin cần thiết để điều hướng sang view Movie Detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show detail":
                let movieDetailVC = segue.destination as! MovieDetailViewController
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    movieDetailVC.id = idAtIndexPath(indexPath: indexPath as NSIndexPath)
                    movieDetailVC.image = imageAtIndexPath(indexPath: indexPath as NSIndexPath)
                }
                break
                
            default:
                break
            }
        }
    }
    
    // MARK: - Helper Method
    
    func idAtIndexPath(indexPath: NSIndexPath) -> Int
    {
        return movies[indexPath.row].id!
    }
    
    func imageAtIndexPath(indexPath: NSIndexPath) -> UIImage
    {
        return movies[indexPath.row].image!
        
    }
    
}
