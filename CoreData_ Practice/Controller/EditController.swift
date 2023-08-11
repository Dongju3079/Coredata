import UIKit

class EditController: UIViewController {
    
    // MARK: - 버튼
    @IBOutlet weak var redBT: UIButton!
    @IBOutlet weak var greenBT: UIButton!
    @IBOutlet weak var blueBT: UIButton!
    @IBOutlet weak var purpleBT: UIButton!
    
    lazy var buttons: [UIButton] = [redBT, greenBT, blueBT, purpleBT]
    
    // MARK: - 텍스트 뷰
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoText: UITextView!
    
    // MARK: - 버튼
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - 기본설정
    let memoManager = CoreDataManager.shared
    
    var memo: MemoData? {
        didSet {
            colorNum = (memo?.color)!
        }
    }
    
    var colorNum: Int16 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        defaultButtonColor()
        setupData()
    }
    
    // MARK: - 기본 UI
    func setupUI() {
        memoText.delegate = self
        memoText.backgroundColor = .clear
        memoView.clipsToBounds = true
        memoView.layer.cornerRadius = 10
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 8
    }
    
    func defaultButtonColor() {
        var colorInt: Int16 = 0
        
        buttons.forEach {
            $0.backgroundColor = MyColor(rawValue: colorInt + 1)?.backgoundColor
            $0.setTitleColor(MyColor(rawValue: colorInt + 1)?.buttonColor, for: .normal)
            colorInt += 1
        }
    }
    
    // 높이를 사용해서 layer를 변경하기 때문에 레이아웃 설정이 끝난 시점인 viewDidLayoutSubviews 사용
    override func viewDidLayoutSubviews() {
        buttons.forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = $0.bounds.height / 2
        }
    }
    // MARK: - 데이터 설정
    func setupData() {
        if let data = memo {
            saveButton.setTitle("UPDATE", for: .normal)
            memoText.text = data.text
            memoText.becomeFirstResponder()
            colorSwitch(num: colorNum)
            // 키보드 바로 올라오게
        } else {
            saveButton.setTitle("SAVE", for: .normal)
            memoText.text = "메모를 입력하세요."
            memoText.textColor = .lightGray
            colorSwitch(num: colorNum)
        }
    }
    // MARK: - 색깔 버튼 클릭 시
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        defaultButtonColor()
        let colorTag = Int16(sender.tag)
        colorNum = colorTag
        colorSwitch(num: colorTag)
    }
    
    func colorSwitch(num: Int16) {
        switch num {
        case 1 ... 4:
            setupColor(num)
        default:
            setupColor(1)
        }
    }
    
    func setupColor(_ num: Int16) {
        let intNum = Int(num)
        memoView.backgroundColor = MyColor(rawValue: num)?.backgoundColor
        buttons[intNum - 1].backgroundColor = MyColor(rawValue: num)?.buttonColor
        buttons[intNum - 1].setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = MyColor(rawValue: num)?.buttonColor
    }
    // MARK: - 데이터 저장
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let data = memo {
            data.text = memoText.text
            data.color = colorNum
            
            memoManager.updateToDo(newToDoData: data) {
                print("업데이트 완료")
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            memoManager.saveToDoData(toDoText: memoText.text, colorInt: colorNum) {
                print("저장완료")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension EditController: UITextViewDelegate {
    // 입력을 시작할때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모를 입력하세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "메모를 입력하세요."
            textView.textColor = .lightGray
        }
    }
}
