//
//  MenuPageViewController.swift
//  WordGuessing
//
//  Created by Ly Ly Dang on 4/2/19.
//  Copyright © 2019 DeAnza. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MenuPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the main menu page
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other pages
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
