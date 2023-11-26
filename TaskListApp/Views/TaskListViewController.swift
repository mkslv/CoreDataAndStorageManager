//
//  ViewController.swift
//  TaskListApp
//
//  Created by Max Kiselyov on 11/23/23.
//

import UIKit

final class TaskListViewController: UITableViewController {
    // MARK: - Properties
    
    private let storageManager = StorageManager.shared
    private var taskList: [Tasker]!
    
    // MARK: - Lifecyckle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        
        fetchData()
        
    }
    
    // MARK: - Methods
    
    private func fetchData() {
        storageManager.fetchData { [unowned self] result in
            switch result {
            case .success(let data):
                self.taskList = data
                tableView.reloadData()
            case .failure(let error):
                print(error)
                present(AlertManager.showAlert(with: "Error", and: error.localizedDescription), animated: true)
            }
        }
    }
    
    @objc
    private func addNewTask() {
        let taskVC = CteateTaskViewController()
        // classic: navigationController?.pushViewController(taskVC, animated: true)
        taskVC.delegate = self
        present(taskVC, animated: true)
    }
}

// MARK: - Setting up View

private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // setup NavBar Apperance
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.configureWithOpaqueBackground() // делаем полупрозрачным с блюром
        
        navBarApperance.backgroundColor = UIColor(named: "MilkBlue")
        
        navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white] // для маленького текста
        navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // для большого текста
        
        navigationController?.navigationBar.standardAppearance = navBarApperance // для маленького нав бара
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance // для большого нав бара
        
        // set button
        let plusBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        navigationItem.rightBarButtonItem = plusBarButton
        navigationController?.navigationBar.tintColor = .white
        
        // настроим Statuc bar style (сеть батарея часы и пр)

    }
}

// MARK: - TaskViewControllerDelegate
extension TaskListViewController: TaskCreatorDelegate {
    func addTask(name: String) {
        storageManager.addTask(name) { task in
            fetchData()
            // taskList.append(task)
            // tableView.reloadData()
        }
    }
}

// MARK: - tableView create cells
extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = taskList else { return 0 }
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - tableView delete cell
extension TaskListViewController {
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        // create an action
        let action = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in 
            // which task should be deleted
            let taskToDelete = self.taskList[indexPath.row]
            self.storageManager.delete(taskToDelete)
            self.fetchData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}


// MARK: - settingCellAction
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task: Tasker = taskList[indexPath.row]
        let detailVC = DetailTaskViewController()
        detailVC.task = task
        navigationController?.pushViewController(detailVC, animated: true)
        
        // Снимаем выделение с ячейки
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
