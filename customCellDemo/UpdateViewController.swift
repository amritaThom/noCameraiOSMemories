//
//  ImagePickerController.swift
//  customCellDemo
//
//  Created by Amy Giver on 9/14/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import Foundation
import UIKit

class UpdateViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PictureDelegate {
    
    
    // on this page we're either adding data or editing existing data, so we have to keep track of information being passed around. We'll need delegates! Depending on how we got here, we'll need either a meories delegate or an updating delegate.
    weak var cancelButtonDelegate: CancelButtonDelegate?
    weak var memoriesDelegate: MemoryDelegate?
    weak var updatingDelegate: UpdatingDelegate?
    var newNameForMemory: String?
    var memoryToUpdate: Memory?
    var nameOfPicture: String?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        //when someone presses the done button, let's check if the memory has a name. If it doesn't have a name, let's not bother saving it, because that's just annoying, they should have to try again.
       
        if let newName = nameTextField.text, let newDesc = descriptionTextArea.text {
                if newName == "" {
                //if there is no name, cancel by calling on our delegate
                cancelButtonDelegate?.cancelButtonPressedFrom(self)
            }
            else {
                    // if they did provide a good name in the text field, but that in the global scope by assigning it to newNameForMemory
                newNameForMemory = newName
                if let updatedMemory = memoryToUpdate {
                    // this we'll check whether we're updating or adding something new. Here, we're updating, so we'll take the existing memory we were given and override its name, desc, and fileName with the current information we have on this page.
                    updatedMemory.name = newName
                    updatedMemory.desc = newDesc
                    updatedMemory.fileName = nameOfPicture
                    // and then tell our updating delegate to update the memory
                    updatingDelegate?.updatingExistingMemory(updatedMemory)
                }
                else {
                    // it's a new memory, we're not updating, we're adding
                    if let picName = nameOfPicture {
                        // safely check to make sure a picture was assigned, then call on our memories delegate to add the new memory
                        memoriesDelegate?.imagePickerController(didFinishWritingMemory: newName, memoryDesc: newDesc, memoryFileName: picName)
                    }
                    else {
                        // if somehow something weird happened and there is no picture, just default to the snail picture.
                        let picName = "snail"
                        // call on the delegate to add the new memory to core data
                        memoriesDelegate?.imagePickerController(didFinishWritingMemory: newName, memoryDesc: newDesc, memoryFileName: picName)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var descriptionTextArea: UITextView!
    
    @IBOutlet weak var chosenImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenImage.contentMode = .ScaleAspectFit
        if let currentmemory = memoryToUpdate {
            // if we're updating a current memory, we'll use the information to populate our fields on this page
            nameTextField.text = currentmemory.name
            descriptionTextArea.text = currentmemory.desc
            nameOfPicture = currentmemory.fileName
            chosenImage.image = UIImage(named: nameOfPicture!)

        }
        
    }

    @IBAction func addingButtonPressed(sender: UIButton) {
        // if someone wants to change the picture of the memory, we'll use the segue choosePicture. But not before visiting PrepareForSegue!!!
        performSegueWithIdentifier("choosePicture", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "choosePicture"{
            // if we're going down the choosePicture segue, our controller will be the PictureCollectionViewController. This is a Show segue, so the code is a little shorter than you might normally be used to with presenting modally
            let controller = segue.destinationViewController as! PictureCollectionViewController
            // and this page is the next controller's choosingPictureDelegate
            controller.choosingPictureDelegate = self
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        // when someone presses the cancel button, we pass the job off to our cancel button delegate
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    func newPictureChosen(withName: String) {
        // once a new picture is chosen from the next view controller, that triggers this function, which updates the picture that we see. To make it globally available, set it to our nameOfPicture variable that we declared at the top of the page
        chosenImage.image = UIImage(named: withName)
        nameOfPicture = withName
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
