//
//  Extensions.swift
//  To Do List. ТЗ
//
//  Created by Гидаят Джанаева on 03.09.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView ...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}


