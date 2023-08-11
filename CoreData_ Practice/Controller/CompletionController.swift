//
//  CompletionController.swift
//  CoreData_ Practice
//
//  Created by Macbook on 2023/08/11.
//

import UIKit

class CompletionController: UIViewController {
    
    
    @IBOutlet weak var completionTable: UITableView!
    
    let memoManager = CoreDataManager.shared
    let completionManager = CompletionCoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupNavi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        completionTable.reloadData()
    }
    
    func setupNavi() {
        title = "Completion List"
    }
    
    func setupTable() {
        completionTable.dataSource = self
        completionTable.delegate = self
        
        completionTable.separatorStyle = .none
    }
}

extension CompletionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completionManager.getToDoListFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletionCell", for: indexPath) as! CompletionCell
        
        cell.memoData = completionManager.getToDoListFromCoreData()[indexPath.row]
        
        cell.selectionStyle = .none
        
        
        return cell
    }
}

extension CompletionController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let recoveryAction = UIContextualAction(style: .normal, title: "Recover") { (action, view, completionHandler) in
            self.memoManager.recoveryToDoData(recoveryData: self.completionManager.getToDoListFromCoreData()[indexPath.row]) { /* 클로저 구현 */ }
            
            self.completionManager.deleteToDo(data: self.completionManager.getToDoListFromCoreData()[indexPath.row]) {
                tableView.reloadData()
            }
            completionHandler(true)
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            self.completionManager.deleteToDo(data: self.completionManager.getToDoListFromCoreData()[indexPath.row]) {
                tableView.reloadData()
            }
            completionHandler(true)
        }
        
        let myColor = self.completionManager.getToDoListFromCoreData()[indexPath.row].color
        
        recoveryAction.backgroundColor = MyColor(rawValue: myColor)?.backgoundColor
        recoveryAction.image = UIImage(systemName: "repeat.circle")
        
        deleteAction.backgroundColor = MyColor(rawValue: myColor)?.buttonColor
        deleteAction.image = UIImage(systemName: "trash.circle")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, recoveryAction])
        // 스와이프 끝까지 : configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
