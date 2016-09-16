//
//  CollectionViewController.swift
//  MyDogs
//
//  Created by Blaine Mercado on 9/14/16.
//  Copyright © 2016 Blaine Mercado. All rights reserved.
//

import Foundation
import UIKit

class GameOverViewController: UIViewController{
    weak var delegate: GameOverViewControllerDelegate?
    var score: Double?
    
    @IBAction func restartButtonPressed(sender: UIButton) {
        delegate?.gameOverViewController(self, didFinishGame: score!)
    }
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = String(score!)
        
    }
}