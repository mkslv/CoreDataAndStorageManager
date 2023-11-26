//
//  AlertManager.swift
//  TaskListApp
//
//  Created by Max Kiselyov on 11/26/23.
//

import UIKit

final class AlertManager {
    static func showAlert(with title: String, and message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        return alert
    }
}
