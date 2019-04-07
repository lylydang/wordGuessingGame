//
//  PopupViewController.swift
//  WordGuessing
//
//  Created by Ly Ly Dang on 4/5/19.
//  Copyright © 2019 DeAnza. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    var parentVC: ViewController?
    
    @IBOutlet weak var difficultyLevel: UILabel!
    
    @IBAction func difficultySlider(_ sender: UISlider) {
        let currentValue  = Int(sender.value)
        difficultyLevel.text = "\(currentValue)"
    }
    
    @IBAction func closePopup(_ sender: Any) {
        parentVC?.levelOfDiffculty = difficultyLevel.text! //pass back difficult level from slider to the main view
        parentVC?.resetGame() //reset the game when the player closes the popup
        self.view.removeFromSuperview() //close the popup
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }

}
