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

    public var calendarLayout : CalendarLayout! = CalendarLayout(){
        didSet{
            self.backgroundColor = calendarLayout.weekViewBgColor
        }
    }
    
    override  public  init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public  func loadUI(){
        let weekDays: [String] = ["日","一","二","三","四","五","六"]
        for (index,string) in weekDays.enumerated() {
            let dayLabel: UILabel = {
                let label = UILabel()
                label.text = string
                if index == 0 || index == 6 {
                    label.textColor = calendarLayout.weekViewendColor
                }else{
                    label.textColor = calendarLayout.weekViewDayColor
                }
                label.font = UIFont.systemFont(ofSize: 14)
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
