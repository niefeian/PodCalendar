//
//  WeekView.swift
//  PodCalendar
//
//  Created by 聂飞安 on 2019/8/15.
//

import UIKit

open class WeekView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    public var calendarLayout : CalendarLayout! = CalendarLayout()
    
    override  public  init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 115/255, green: 201/255, blue: 188/255, alpha: 1)
        
        let weekDays: [String] = ["日","一","二","三","四","五","六"]
        for (index,string) in weekDays.enumerated() {
            let dayLabel: UILabel = {
                let label = UILabel()
                label.text = string
                label.textColor = UIColor.white
                label.textAlignment = .center
                return label
            }()
            dayLabel.frame = CGRect(x: CGFloat(index)*(frame.width/7), y: 0, width: frame.width/7, height: 30)
            self.addSubview(dayLabel)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
