//
//  AnimationViewController.swift
//  WordGuessing
//
//  Created by Ly Ly Dang on 4/5/19.
//  Copyright © 2019 DeAnza. All rights reserved.
//

import UIKit
import Lottie

class AnimationViewController: UIViewController {

    @IBOutlet var loaderAnimationView: AnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }
    
    func startAnimation(){
        let starAnimation = Animation.named("loadingAnimation")
        loaderAnimationView.animation = starAnimation
        loaderAnimationView.play(completion: {_ in self.performSegue(withIdentifier: "segueFromAnimationView", sender: nil)})
    }
    
}
