//
//  ViewController.swift
//  customCellDemo
//
//  Created by Amy Giver on 9/14/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import CoreData


class HomeViewController: UITableViewController, CancelButtonDelegate, MemoryDelegate, FancyCellDelegate {
   
    
    var importantMemory = 0
    //this is the array holding onto our Memory objects
    var memories = [Memory]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Very important to fetch all Memories out of Core Data right away
        
        fetchAllMemories()
    }

   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
       
    func fetchAllMemories(){
        let memoryRequest = NSFetchRequest(entityName: "Memory")
        do {
            let results = try managedObjectContext.executeFetchRequest(memoryRequest)
            memories = results as! [Memory]
        }
        catch {
            print("\(error)")
        }
    }
    

    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        // When we press the add button, we'll go along the adding segue, but of course we'll swing by PrepareForSegue first
        performSegueWithIdentifier("addingSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        // if we want to go down the adding segue...
        if segue.identifier == "addingSegue"{
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! UpdateViewController
            //...our controller will be the UpdateViewController, and we'll assign ourselves as its Cancel Button Delegate and its Memories Delegate
            controller.cancelButtonDelegate = self
            controller.memoriesDelegate = self

        }
        // if we want to go down the details segue....
        if segue.identifier == "detailsSegue"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! DetailsViewController
            // ... our controller will be the Details View Controller, and we'll assign ourselves as its cancel Button Delegate, its Memories Delegate, and tell it which memory we want to study in closer detail
            controller.cancelButtonDelegate = self
            controller.memoriesDelegate = self
            controller.memoryToStudy = memories[importantMemory]
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // We need as many cells as there are memories in the memories array
        return memories.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // we want to use our custom cell class, so all the cells we're building are from the Fancy Cell class
        let cell = tableView.dequeueReusableCellWithIdentifier("fancyCell") as! FancyCell
        // the name of the picture we want can be found by looking at the filename for the memory object found in the appropriate index of the memories array
        let picName = memories[indexPath.row].fileName!
        // with the name of the pic, we can now put the right image into the image view in the fancy cell
        cell.fancyCellImage.image = UIImage(named: picName)
        
        // we'll find the name to go into the name outlet label in the fancy cell by going to the memories array and looking at the correct index and selecting its name property
        cell.nameOutlet?.text = memories[indexPath.row].name
        // the cell's button delegate should be this view controller
        cell.buttonDelegate = self
        
        return cell
    }
    
    
    
    //////////////////////////////DELEGATE STUFF //////////////////////////////////////
    
    
    func cancelButtonPressedFrom(controller: UIViewController){
        
        //when another view controller calls upon this page as the delegate to run this method, this dismisses the top view controller. Since there may have been changes to our core data, just to be on the safe side, we'll fetch all memories again and reload the table view.
        dismissViewControllerAnimated(true, completion: nil)
        fetchAllMemories()
        tableView.reloadData()
        
    }
    
    func descriptionButtonPressedFrom(cell: FancyCell) {
        // When someone presses the description button found inside the fancy cell, this method will be called. We'll need to note which cell it was, because this will help us find the appropriate memory in the memories array
        let index = tableView.indexPathForCell(cell as UITableViewCell)?.row
        // the important memory that we want to take a closer look at will be found at this index
        importantMemory = index!
        
        //perform the segue to the details page, but not before visiting PrepareForSegue!
        performSegueWithIdentifier("detailsSegue", sender: self)
        
    }
    
    func imagePickerController(didFinishWritingMemory memoryName: String, memoryDesc: String, memoryFileName: String){
        
        //when a new memory is made, we'll have to store this in core data
        // dismiss the top view controller
        dismissViewControllerAnimated(true, completion: nil)
        // create the object in Core Data
        let entity = NSEntityDescription.entityForName("Memory", inManagedObjectContext: managedObjectContext)
        let newMemory = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        newMemory.setValue(memoryName, forKey: "name")
        newMemory.setValue(memoryDesc, forKey: "desc")
        newMemory.setValue(memoryFileName, forKey: "fileName")
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success")
            }
            catch {
                print("\(error)")
            }
        }
        // Since we added something to core data, let's fetch them all again and reload the table view.
        fetchAllMemories()
        tableView.reloadData()
    }
    func imagePickerController(){
        
        // When we're all done updating a memory, all we have to do is check if the managed object context has changes. 
        if managedObjectContext.hasChanges {
            do { try managedObjectContext.save()
                print("success in updating")
            }
            catch {
                print("\(error)")
            }
        }

    }


}

