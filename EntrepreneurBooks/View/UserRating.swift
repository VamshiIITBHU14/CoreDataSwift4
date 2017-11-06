//
//  UserRating.swift
//  EntrepreneurBooks
//
//  Created by Priyanka Pote on 06/11/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import Foundation
import UIKit

class UserRating: UIView {
    
    var rating = 0 {
        didSet {
            //Trigger a layout update
            setNeedsLayout()
        }
    }
    
    var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "yellowstar")
        let emptyStarImage = UIImage(named: "blackstar")
        
        for _ in 0..<stars {
            let button = UIButton()
            
            button.setImage(emptyStarImage, for: UIControlState.normal)
            button.setImage(filledStarImage, for: UIControlState.selected)
            button.adjustsImageWhenHighlighted = false
            
            ratingButtons += [button]
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        var x = 0
        
        // Offset each button's origin by the length of button plus spacing
        for button in ratingButtons {
            buttonFrame.origin.x = CGFloat(x * (buttonSize + spacing))
            button.frame = buttonFrame
            x += 1
        }
        
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        var x = 0
        
        for button in ratingButtons {
            // if the index of a button is less than the rating, that button should be selected
            button.isSelected = x < rating
            x += 1
        }
    }
}
