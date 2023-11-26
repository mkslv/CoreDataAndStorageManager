//
//  DetailTaskViewController.swift
//  TaskListApp
//
//  Created by Max Kiselyov on 11/26/23.
//

import UIKit

final class DetailTaskViewController: UITableViewController {
    // MARK: - Properties
    var task: Tasker! {
        didSet {
            fetchData()
        }
    }
    
    // MARK: - Private properties
    private let storageManager = StorageManager.shared
    private var subtaskList: [Subtasker]!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
    }
    
    
    // MARK: - Methods
    
    private func fetchData() {
        storageManager.fetchSubtaskData(for: task) { [unowned self] result in
            switch result {
            case .success(let data):
                self.subtaskList = data
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc
    private func addNewSubTask() {
        let taskVC = CteateTaskViewController()
        taskVC.delegate = self
        present(taskVC, animated: true)
    }

    
}

// MARK: - Setting up View

private extension DetailTaskViewController {
    func setupNavigationBar() {
        title = "Subtasks"
        navigationController?.navigationBar.prefersLargeTitles = true

        // set button
        let plusBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewSubTask))
        
        navigationItem.rightBarButtonItem = plusBarButton
        navigationController?.navigationBar.tintColor = .white
        
        // настроим Statuc bar style (сеть батарея часы и пр)

    }
}

// MARK: - TaskViewControllerDelegate
extension DetailTaskViewController: TaskCreatorDelegate {
    func addTask(name: String) {
        storageManager.addSubtask(name, for: task) { subtask in
            fetchData()
        }
    }
}

// MARK: - TableView
extension DetailTaskViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = subtaskList else { return 0 }
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = subtaskList[indexPath.row].name
        content.secondaryText = "\(subtaskList[indexPath.row].isImportant)"
        cell.contentConfiguration = content
        print(subtaskList[indexPath.row])
        return cell
    }
    
    
}

// MARK: - tableView delete cell
extension DetailTaskViewController {
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        // create an action
        let action = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in
            // which task should be deleted
            let taskToDelete = self.subtaskList[indexPath.row]
            self.storageManager.delete(taskToDelete)
            self.fetchData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

