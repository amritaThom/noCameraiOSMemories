//
//  PictureCollectionViewCell.swift
//  customCellDemo
//
//  Created by Amy Giver on 11/11/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
import UIKit

class PictureCollectionViewController: UICollectionViewController {
    // this view controller inherits from UICollectionViewController! It's a lot like a table view controller, but niftier.
    
    // This is done in place of using the camera roll. If you went ahead and used the camera roll, that's awesome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // an array of all the pictures in the assets folder
    let allAvailablePictures = ["alligator", "bee", "cauliflower", "dragon", "eeyore", "emu", "fantasy", "grimreaper", "kiwi", "ostrich", "penguins", "snail", "harry", "iguana", "jam", "kidney"]
    
    
    // we'll need a delegate to pass the information we gather from here back to the other view controllers
    var choosingPictureDelegate: PictureDelegate?
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allAvailablePictures.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! CollectionViewCustomCell
        cell.collectionimage.image = UIImage(named: allAvailablePictures[indexPath.item])
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // well someone selects an item in the colelction view, use its index path to know which picture it is in the array of allAvailablePictures
        let index = indexPath.item
        // pass this information on to the delegate and make it run its method newPictureChosen
        choosingPictureDelegate?.newPictureChosen(allAvailablePictures[index])
    }
    
}
