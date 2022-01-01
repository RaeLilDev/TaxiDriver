//
//  CustomerTableViewCell.swift
//  TaxiDriver
//
//  Created by Ye Lynn Htet on 29/12/2021.
//

import UIKit
import Alamofire
import AlamofireImage

class CustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cusNameLabel: UILabel!
    @IBOutlet weak var cusPhoneLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileContainerView.layer.cornerRadius = 8
        profileImage.layer.cornerRadius = 8
    }

    
    func configure(with model: CustomerModel) {
        
        cusNameLabel.text = model.cusName
        cusPhoneLabel.text = model.cusPhone
        distanceLabel.text = "\(model.cusDistance)km"
        let imgURL = model.cusPhoto
        setImage(with: imgURL)
        
    }
    
    func setImage(with urlString: String) {
        let url = URL(string: urlString)!
        let placeholderImage = UIImage(named: "profile_sample")

        profileImage.af.setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.2))
    }
    
}
