//
//  DetailsViewController.swift
//  customCellDemo
//
//  Created by Amy Giver on 9/14/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, CancelButtonDelegate, UpdatingDelegate {
    
    // On this page we'll be passing data back and forth, so we need a delegate to handle that for us. Our memories delegate is in charge of data. Our cancel button delegate is only for the cancel button
    weak var memoriesDelegate: MemoryDelegate?
    // from the previous view controller, we'll find out which memory we're supposed to take a closer look at.
    weak var memoryToStudy: Memory?
    weak var cancelButtonDelegate: CancelButtonDelegate?
    
    @IBOutlet weak var imageToStudy: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // When someone wants to press the update button, we'll have to go along the updating segue. But not before visiting Prepare for Segue!
    @IBAction func updateButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("updatingSegue", sender: self)
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        // If someone presses the cancel button, we'll just make the delegate take care of that.
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        if segue.identifier == "updatingSegue" {
            //if we're going to use the updating segue, our controller will be the Update View Controller
            let controller = navigationController.topViewController as! UpdateViewController
            controller.cancelButtonDelegate = self
            controller.updatingDelegate = self
            // this page will the the next page's updating delegate
            if let impmem = memoryToStudy {
                // safely unwrapping our memory to study and sending that along to the next page as its memory to update
                controller.memoryToUpdate = impmem
            }
        }
        
    }
    
    func cancelButtonPressedFrom(controller: UIViewController){
        // if someone proceeded on to the UpdateViewController, then we need to be its cancel button delegate
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let memory = memoryToStudy {
            
            // when we receive a memory from the previous view controller, we use it to decide how to populate our labels, text views, and image fields.
            nameLabel.text = memory.name
            descriptionTextView.text = memory.desc
            imageToStudy.image = UIImage(named: memory.fileName!)
           
        }
        imageToStudy.contentMode = .ScaleAspectFit

    }
 

    
    func updatingExistingMemory(memory: Memory) {
        // if someone updates the memory on the next page, we'll dismiss that top view controller.
        dismissViewControllerAnimated(true, completion: nil)
        // and then refer to our own delegate, which can actually save the changes to core data
        memoriesDelegate?.imagePickerController()
        
        // on this view controller, we'll use the changes made by their actions to update the label text, text field text, and image.
        nameLabel.text = memory.name
        descriptionTextView.text = memory.desc
        imageToStudy.image = UIImage(named: memory.fileName!)

    }
   

}

