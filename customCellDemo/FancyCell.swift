//
//  FancyCell.swift
//  customCellDemo
//
//  Created by Amy Giver on 9/14/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit

class FancyCell: UITableViewCell {
    
    var buttonDelegate: FancyCellDelegate?
    
    @IBOutlet weak var nameOutlet: UILabel!
    
    @IBOutlet weak var fancyCellImage: UIImageView!
  
    

    @IBAction func fancyfancybutton(sender: UIButton) {
        
        buttonDelegate?.descriptionButtonPressedFrom(self)
    }
    
    
}
