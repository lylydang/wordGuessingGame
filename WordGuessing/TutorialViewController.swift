//
//  TutorialViewController.swift
//  WordGuessing
//
//  Created by Ly Ly Dang on 4/4/19.
//  Copyright © 2019 DeAnza. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var tutorialText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColor = UIColor.gray.cgColor
        let cornerRadius: CGFloat = 7
        let borderWidth: CGFloat = 0.8
        
        //Customize tutorial text field
        tutorialText.layer.borderColor = myColor
        tutorialText.layer.cornerRadius = cornerRadius
        tutorialText.layer.borderWidth = borderWidth
 
    }

}
