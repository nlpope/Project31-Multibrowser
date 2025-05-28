//  File: UIAlertController+Ext.swift
//  Project: Project31-Multibrowser
//  Created by: Noah Pope on 5/28/25.

import UIKit

extension UIAlertController
{
    func addActions(_ actions: UIAlertAction...)
    {
        for action in actions { self.addAction(action) }
    }
}
