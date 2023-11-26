//
//  FilledButtonFactory.swift
//  TaskListApp
//
//  Created by Max Kiselyov on 11/24/23.
//

import UIKit

protocol ButtonFactory {
    func createButton() -> UIButton
}

final class FilledButtonFactory {
    let title: String
    let color: UIColor
    let action: UIAction
    
    init(title: String, color: UIColor, action: UIAction) {
        self.title = title
        self.color = color
        self.action = action
    }
}

extension FilledButtonFactory: ButtonFactory {
    func createButton() -> UIButton {
        
        // настройки текста
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 20)
        
        // настройки кнопки
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = color
//        buttonConfiguration.buttonSize = .medium
//        buttonConfiguration.title = "Save task"
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        
        let button = UIButton(configuration: buttonConfiguration, primaryAction: action)
        return button
    }
    
    
}
