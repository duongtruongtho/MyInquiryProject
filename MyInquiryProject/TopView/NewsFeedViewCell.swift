//
//  NewsFeedViewCell.swift
//  MyInquiryProject
//
//  Created by Dương Thảnh Hải Trường Thọ on 12/17/16.
//  Copyright © 2016 ThoPhat. All rights reserved.
//

import UIKit

class NewsFeedViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var describeImageView: UIImageView!
    @IBOutlet weak var numberOfFavoriteLabel: UILabel!
    @IBOutlet weak var numberOfCommentLabel: UILabel!
    @IBOutlet weak var numberOfReviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UIImageView.downloadImage(url: URL(string: "https://ichef.bbci.co.uk/images/ic/480x270/p02917p9.jpg")!, withCompleteBlock: { [weak self] (image: UIImage?) in
            if let image = image {
                self?.describeImageView.image = image
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
