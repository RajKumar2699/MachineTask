//
//  ViewController.swift
//  MachineTask
//
//  Created by ADMIN on 30/11/23.
//

import UIKit

class HeadLineVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headlineTableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!

    
    var headlines: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        headlineTableView.register(UINib(nibName: Constants.TableView.headlineCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.TableView.headlineCellIdentifier)
        headlineTableView.rowHeight = UITableView.automaticDimension
        headlineTableView.estimatedRowHeight = CGFloat(Constants.TableView.estimatedRowHeight)
        fetchData {
            print("Data fetch completed")
        }
    }

    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    func fetchData(completion: @escaping () -> Void) {
        activityIndicator.startAnimating()
        
        guard let url = URL(string: Constants.API.newsAPIURL) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NewsApiResponse.self, from: data)
                
                self.headlines = response.articles
                
                DispatchQueue.main.async {
                    self.headlineTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    completion()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    // MARK: - Table View Delegate and Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.headlineCellIdentifier, for: indexPath) as! HeadLineScreenTVC

        let headline = headlines[indexPath.row]
        cell.titleLbl.text = headline.title
        cell.authorLbl.text = headline.author
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: headline.publishedAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-d"
            let formattedDate = dateFormatter.string(from: date)
            cell.datelbl.text = formattedDate
        } else {
            cell.datelbl.text = "Invalid Date"
        }
        
        if let imageUrlString = headline.urlToImage, let imageUrl = URL(string: imageUrlString) {
                   URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    cell.headlineImg.image = UIImage(data: data)
                }
            }.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "HeadlineDetailVC") as! HeadlineDetailVC
        secondVC.selectedHeadline = headlines[indexPath.row]
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}
