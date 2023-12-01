//
//  HeadlineDetailVC.swift
//  MachineTask
//
//  Created by ADMIN on 30/11/23.
//

import UIKit

class HeadlineDetailVC: UIViewController {
    
    @IBOutlet weak var headlineImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var selectedHeadline: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    @IBAction func bckBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateUI() {
        guard let headline = selectedHeadline else { return }
        titleLbl.text = headline.title
        authorLbl.text = headline.author
        descriptionLbl.text = headline.description
        
        if let imageUrlString = headline.urlToImage, let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    UIView.transition(with: self.headlineImg,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.headlineImg.image = UIImage(data: data)
                                      },
                                      completion: nil)
                }
            }.resume()
        }
        
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: headline.publishedAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-d"
            let formattedDate = dateFormatter.string(from: date)
            dateLbl.text = formattedDate
        } else {
            dateLbl.text = "Invalid Date"
        }
    }
}
