//
//  Header.swift
//  Final-Coll
//
//  Created by ECENUR on 21.02.2021.
//

import UIKit

class Header: UICollectionReusableView {
    static let identifier = "Header"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    public func setLabel(size: CGFloat, bold: Bool){
        if bold {
            label.font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
        }
        label.font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
}
 
