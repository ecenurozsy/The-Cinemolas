//
//  SplashViewController.swift
//  Final-Coll
//
//  Created by ECENUR on 22.02.2021.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
            self.performSegue(withIdentifier: "goTable", sender: nil)}
    }

}
