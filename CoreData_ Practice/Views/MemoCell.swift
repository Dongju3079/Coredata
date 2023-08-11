//
//  MemoCell.swift
//  CoreData_ Practice
//
//  Created by Macbook on 2023/08/10.
//

import UIKit

class MemoCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var memoData: MemoData? {
        didSet {
            setupData()
        }
    }
    
    var buttonPressed: (MemoCell) -> () = { (sender) in }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - UI
    func setupUI() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 8
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
    }
    // MARK: - Setup Data
    func setupData() {
        memoLabel.text = memoData?.text
        dateLabel.text = memoData?.dateString
        
        let myColor = MyColor(rawValue: memoData!.color)
        
        backView.backgroundColor = myColor?.backgoundColor
        button.backgroundColor = myColor?.buttonColor
    }
    // MARK: - Edit
    
    @IBAction func updatePressed(_ sender: UIButton) {
        buttonPressed(self)
    }

}
