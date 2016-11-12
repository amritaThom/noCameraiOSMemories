//
//  MemoryDelegate.swift
//  customCellDemo
//
//  Created by Amy Giver on 9/14/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import Foundation
import UIKit

protocol MemoryDelegate: class {
    func imagePickerController(didFinishWritingMemory memoryName: String, memoryDesc: String, memoryFileName: String)
    
    func imagePickerController()
}
