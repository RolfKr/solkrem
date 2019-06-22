//
//  TempView.swift
//  Solkrem?
//
//  Created by Rolf Kristian Andreassen on 22/06/2019.
//  Copyright © 2019 Rolf Kristian Andreassen. All rights reserved.
//

import UIKit

class TempView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 5
    }

}
