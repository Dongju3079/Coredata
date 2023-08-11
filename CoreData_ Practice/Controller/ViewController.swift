//
//  ViewController.swift
//  CoreData_ Practice
//
//  Created by Macbook on 2023/08/10.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var memoTableView: UITableView!
    
    let memoManager = CoreDataManager.shared
    let completionManager = CompletionCoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          memoTableView.reloadData()
      }
    
    // 네비설정
    func setupNavi() {
        title = "MemoList"
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        button.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func plusButtonTapped() {
        performSegue(withIdentifier: "editMemo", sender: nil)
    }
    
    // 테이블뷰 설정
    func setupTable() {
        memoTableView.dataSource = self
        memoTableView.delegate = self
        
        memoTableView.separatorStyle = .none
    }
    
    func reloadData() {
        memoTableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoManager.getToDoListFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
        
        cell.memoData = memoManager.getToDoListFromCoreData()[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.buttonPressed = { [weak self] (sender) in
            self?.performSegue(withIdentifier: "editMemo", sender: indexPath)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMemo" { // 항상 식별자 먼저 확인
            let memoVC = segue.destination as! EditController // destination : 종착지
            
            guard let indexPath = sender as? IndexPath else { return }
            memoVC.memo = memoManager.getToDoListFromCoreData()[indexPath.row]
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completionAction = UIContextualAction(style: .normal, title: "Finish") { (action, view, completionHandler) in
            self.completionManager.saveToDoData(completionData: self.memoManager.getToDoListFromCoreData()[indexPath.row]) {
                print("완료데이터 이관 완료")
            }
            self.memoManager.deleteToDo(data: self.memoManager.getToDoListFromCoreData()[indexPath.row]) {
                print("삭제됏음")
                print(self.completionManager.getToDoListFromCoreData().first?.text ?? "업데이트 안됨")
                self.memoTableView.reloadData()
            }
            completionHandler(true)
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            self.memoManager.deleteToDo(data: self.memoManager.getToDoListFromCoreData()[indexPath.row]) {
                print("삭제됏음")
                print(self.completionManager.getToDoListFromCoreData().first?.text ?? "업데이트 안됨")
                self.memoTableView.reloadData()
            }
              completionHandler(true)
          }
        let myColor = self.memoManager.getToDoListFromCoreData()[indexPath.row].color
        
        completionAction.backgroundColor = MyColor(rawValue: myColor)?.backgoundColor
        completionAction.image = UIImage(systemName: "checkmark.circle")
        
        deleteAction.backgroundColor = MyColor(rawValue: myColor)?.buttonColor
        deleteAction.image = UIImage(systemName: "trash.circle")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, completionAction])
        // 스와이프 끝까지 : configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
