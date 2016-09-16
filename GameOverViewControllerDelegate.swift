//
//  GameOverViewControllerDelegate.swift
//  MapQuestions
//
//  Created by Blaine Mercado on 9/16/16.
//  Copyright © 2016 Blaine Mercado. All rights reserved.
//

import Foundation
import UIKit
protocol GameOverViewControllerDelegate: class {
    func gameOverViewController(controller: UIViewController, didFinishGame score: Double)
}