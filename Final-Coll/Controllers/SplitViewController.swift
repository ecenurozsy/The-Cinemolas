//
//  SplitViewController.swift
//  Final-Coll
//
//  Created by ECENUR on 23.02.2021.
//

import UIKit

class SplitViewController: UISplitViewController {
    
    let width = UIScreen.main.bounds.width
    let heigth = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .allVisible;
        self.maximumPrimaryColumnWidth = width/2;
        self.minimumPrimaryColumnWidth = heigth/2;
        self.view.backgroundColor = UIColor.white
    }

}
