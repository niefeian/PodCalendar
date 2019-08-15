//
//  CalendarCell.swift
//  PodCalendar
//
//  Created by 聂飞安 on 2019/8/15.
//

import UIKit

open class CalendarCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.config(frame)
    }
   
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    var lunarLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    var dateView: UIView = {
        let dateView = UIView()
        return dateView
    }()
  
    func config(_ frame: CGRect) {
       
        self.addSubview(self.dateView)
        
        dateView.frame = CGRect(x: frame.width/2-(frame.height-10)/2, y: 5, width: frame.height-10, height: frame.height-10)
        dateView.layer.cornerRadius = 5
//        dateView.clipsToBounds = true
        
        dateLabel.frame = CGRect(x: 0, y: 3, width: frame.height-10, height: (frame.height-20)*2/3)
        
        lunarLabel.frame = CGRect(x: 0, y: (frame.height-20)*2/3 + 3, width: frame.height-10, height: (frame.height-20)*1/3)
        
        dateView.addSubview(dateLabel)
        dateView.addSubview(lunarLabel)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
