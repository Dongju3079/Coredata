//
//  CompletionCell.swift
//  CoreData_ Practice
//
//  Created by Macbook on 2023/08/11.
//

import UIKit

class CompletionCell: UITableViewCell {

    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var memoText: UILabel!
    @IBOutlet weak var memoDate: UILabel!
    
    var memoData: CompletionMemo? {
        didSet {
            setupData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - UI
    func setupUI() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 8
    }
    // MARK: - Setup Data
    func setupData() {
        memoText.text = memoData?.text
        memoDate.text = memoData?.dateString
        
        let myColor = MyColor(rawValue: memoData!.color)
        
        backView.backgroundColor = myColor?.backgoundColor

    }

}
