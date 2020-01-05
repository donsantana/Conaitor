//
//  UITextView.swift
//  Conaitor
//
//  Created by Donelkys Santana on 12/14/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit

extension UITextView {

    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }

}
