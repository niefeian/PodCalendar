//
//  CalendarLayout.swift
//  PodCalendar
//
//  Created by 聂飞安 on 2019/8/15.
//

import UIKit

@objc
public protocol CalendarDelegate: NSObjectProtocol {
    @objc optional func getLunarShortName( year : Int , month : Int , day : Int ) -> String?
    @objc optional func getLunarColor(shortName : String  ) -> UIColor?
}

open class CalendarLayout: NSObject {
   
    /* WeekView背景颜色 */
    @objc public var weekViewBgColor: UIColor? = UIColor.white
    @objc public var weekendColor: UIColor? = UIColor.red//周末字体颜色
    @objc public var weekDayColor: UIColor? = UIColor.red//星期一到 星期字体颜色
   
    @objc public var didSelectItemBgColor : UIColor? = UIColor(red: 115/255, green: 201/255, blue: 188/255, alpha: 1)//选中背景颜色
    @objc public var didSelectItemTitleColor : UIColor? = UIColor.white //选中字体颜色
    
    
    @objc public var unSelectItemTitleColor : UIColor? = UIColor.black //未选中字体颜色
    @objc public var unSelectItemLunarTitleColor : UIColor? = UIColor.gray //未选中字体颜色
    @objc public var unSelectItemBgColor : UIColor? = UIColor.white //未选中背景颜色
    
    weak var delegate : CalendarDelegate?
    
}
