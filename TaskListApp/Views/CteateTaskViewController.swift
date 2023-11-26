//
//  TaskViewController.swift
//  TaskListApp
//
//  Created by Max Kiselyov on 11/23/23.
//

import UIKit

protocol TaskCreatorDelegate: AnyObject {
    func addTask(name: String) -> Void
}

final class CteateTaskViewController: UIViewController {
    
    weak var delegate: TaskCreatorDelegate!
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button: ButtonFactory = FilledButtonFactory(
            title: "Save task",
            color: UIColor(named: "MilkBlue") ?? UIColor.darkGray,
            action: UIAction { [unowned self] _ in
                save()
        })
        return button.createButton()
    }()
    
    private lazy var cancelButton: UIButton = {
        let button: ButtonFactory = FilledButtonFactory(
            title: "Cancel",
            color: UIColor(named: "MilkRed") ?? UIColor.lightGray,
            action: UIAction { [unowned self] _ in
                print(#function)
                dismiss(animated: true)
        })
        return button.createButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(taskTextField, saveButton, cancelButton)
        setupConstraints()
    }
    
    func save() {
        if let text = taskTextField.text {
            delegate.addTask(name: text)
            dismiss(animated: true)
        } else {
            // Show alert: Text field is empty
        }
    }
}

// MARK: - Setting view

private extension CteateTaskViewController {
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach {
            view.addSubview($0)
        }
    }
}

// MARK: - Layout

private extension CteateTaskViewController {
    func setupConstraints() {
        [taskTextField, saveButton, cancelButton].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 45),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
