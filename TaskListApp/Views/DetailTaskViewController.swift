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
    private lazy var subtaskList: [Subtasker] = {
        task.subtasks?.array as? [Subtasker] ?? []
    }()
    
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
                present(AlertManager.showAlert(with: "Error", and: error.localizedDescription), animated: true)
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
        subtaskList.count
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

