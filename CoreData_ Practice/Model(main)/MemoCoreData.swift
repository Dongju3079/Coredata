import UIKit
import CoreData

//MARK: - To do 관리하는 매니저 (코어데이터 관리)

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}

    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "MemoData"
    
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveToDoData(toDoText: String?, colorInt: Int16, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                let toDoData = MemoData(entity: entity, insertInto: context)

                toDoData.text = toDoText
                toDoData.date = Date()
                toDoData.color = colorInt
                
                appDelegate?.saveContext()
            }
        }
        completion()
    }
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getToDoListFromCoreData() -> [MemoData] {
        var toDoList: [MemoData] = []
        if let context = context {
            let request = NSFetchRequest<MemoData>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                let fetchedToDoList = try context.fetch(request)
                toDoList = fetchedToDoList
            } catch {
                print("가져오는 것 실패")
            }
        }
        return toDoList
    }
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateToDo(newToDoData: MemoData, completion: @escaping () -> Void) {

        guard let date = newToDoData.date else {
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<MemoData>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
       
                let fetchedToDoList = try context.fetch(request)

                if var targetToDo = fetchedToDoList.first {
                    targetToDo = newToDoData
                    appDelegate?.saveContext()
                }
                completion()
            } catch {
                print("업데이트 실패")
            }
        }
    }
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteToDo(data: MemoData, completion: @escaping () -> Void) {
        guard let date = data.date else {
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<MemoData>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                let fetchedToDoList = try context.fetch(request)
                
                if let targetToDo = fetchedToDoList.first {
                    context.delete(targetToDo)
                    appDelegate?.saveContext()
                }
                completion()
            } catch {
                print("지우는 것 실패")
            }
        }
    }
    // MARK: - [recovery] 코어데이터에 데이터 생성하기
    func recoveryToDoData(recoveryData: CompletionMemo, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                let toDoData = MemoData(entity: entity, insertInto: context)

                toDoData.text = recoveryData.text
                toDoData.date = recoveryData.date
                toDoData.color = recoveryData.color
                
                appDelegate?.saveContext()
            }
        }
        completion()
    }
}
