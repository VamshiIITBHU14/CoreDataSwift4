//
//  BookTableViewCell.swift
//  EntrepreneurBooks
//
//  Created by Priyanka Pote on 06/11/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import UIKit
import CoreData

class BookTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var userRating: UserRating!
    @IBOutlet weak var bookImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func configureCell(book:Book){
        bookNameLabel.text = book.name
        bookAuthorLabel.text = book.author
        userRating.rating = Int(book.rating)
        let imageData = book.image!
        bookImageView.image = UIImage(data:imageData)
    }

}
