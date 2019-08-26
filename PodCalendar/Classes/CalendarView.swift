//
//  CalendarView.swift
//  PodCalendar
//
//  Created by 聂飞安 on 2019/8/15.
//

import UIKit

open class CalendarView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    public var calendarLayout : CalendarLayout! = CalendarLayout()
    private var selectItemAt : IndexPath?
    
    override  public  init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(CalendarCell.self, forCellWithReuseIdentifier: "cell")
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = false
    }
    
    public class func initCalendarView(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout , calendarLayout :  CalendarLayout) -> CalendarView{
        let calendarView = CalendarView(frame: frame, collectionViewLayout: layout)
        calendarView.calendarLayout = calendarLayout
        return calendarView
    }
  
    public var getDatesBlock: ((String)->())?
    
    public  var date: Date = Date() {
        didSet {
            //获取日期所在月份的所有日期
            self.weekday = getFirstDayInDateMonth(date) - 1
            self.days = calculateDaysInDateMonth(date)
        }
    }
    /// 指定日期所在月份的第一天是星期几
    public  var weekday: Int = 0
    private var year: Int = 0
    private var month: Int = 0
    
    /// 指定日期的天数
    public var days: Int = 0 {
        didSet {
            self.tempDay = 1
            self.reloadData()
        }
    }
    /// 用于在对应月份中的
    public  var tempDay: Int = 1
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
     public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCell
        cell.dateView.backgroundColor = calendarLayout.unSelectItemBgColor
        if indexPath.row >= self.weekday && indexPath.row < self.weekday + self.days  {
            cell.dateLabel.text = "\(tempDay)"
            let lunar = formatWithLunar(tempDay, indexPath: indexPath)
            cell.lunarLabel.text = lunar.0
            if  solarToLunar(day: tempDay) == solarToLunar(date: date){
                cell.dateLabel.textColor = calendarLayout.didSelectItemTitleColor
                cell.dateView.backgroundColor = calendarLayout.didSelectItemBgColor
                cell.lunarLabel.textColor = calendarLayout.didSelectItemTitleColor
                selectItemAt = indexPath
            }else{
                cell.dateView.backgroundColor = calendarLayout.unSelectItemBgColor
                cell.lunarLabel.textColor = lunar.1
                cell.dateLabel.textColor = lunar.2
            }
            tempDay += 1
        }else {
            cell.dateLabel.text = ""
            cell.lunarLabel.text = ""
        }
        
        return cell
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        if let text = cell.dateLabel.text ,  text != "" {
            self.getDatesBlock?(text)
            if selectItemAt != nil {
                let cell2 = collectionView.cellForItem(at: selectItemAt!) as! CalendarCell
                let lunar = formatWithLunar(Int(cell2.dateLabel.text ?? "1") ?? 1, indexPath: selectItemAt!)
                cell2.dateView.backgroundColor = calendarLayout.unSelectItemBgColor
                cell2.lunarLabel.textColor = lunar.1
                cell2.dateLabel.textColor = lunar.2
            }
            
            cell.dateLabel.textColor = calendarLayout.didSelectItemTitleColor
            cell.dateView.backgroundColor = calendarLayout.didSelectItemBgColor
            cell.lunarLabel.textColor = calendarLayout.didSelectItemTitleColor
            selectItemAt = indexPath
        }
    }
    
    /// 获取指定月份的天数
     public func calculateDaysInDateMonth(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        //指定日期转换
        let specifiedDateCom = calendar.dateComponents([.year,.month,.day], from: date)
        //指定日期所在月的第一天
        var startCom = DateComponents()
        startCom.day = 1
        startCom.month = specifiedDateCom.month
        startCom.year = specifiedDateCom.year
        
        self.year = specifiedDateCom.year ?? 2018
        self.month = specifiedDateCom.month ?? 1
        let startDate = calendar.date(from: startCom)
        //指定日期所在月的下一个月第一天
        var endCom = DateComponents()
        endCom.day = 1
        endCom.month = specifiedDateCom.month == 12 ? 1 : specifiedDateCom.month! + 1
        endCom.year = specifiedDateCom.month == 12 ? specifiedDateCom.year! + 1 : specifiedDateCom.year
        let endDate = calendar.date(from: endCom)
        //计算指定日期所在月的总天数
        let days = calendar.dateComponents([.day], from: startDate!, to: endDate!)
        let count = days.day ?? 0
        return count
    }
    
    var chineseMonths = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月",
                          "九月", "十月", "冬月", "腊月", nil]
    
    func formatWithLunar(_  day: Int , indexPath: IndexPath) -> (String,UIColor,UIColor) {
        
        if let name = calendarLayout.delegate?.getLunarShortName?(year: year, month: month, day: day) , name != "" {
            return (name,calendarLayout.delegate?.getLunarColor?(shortName: name) ?? calendarLayout.unSelectItemLunarTitleColor!,calendarLayout.delegate?.getSolarColor?(shortName: name) ?? calendarLayout.unSelectItemTitleColor!)
        }
        
        let string = solarToLunar(day: day)
        
        if string.contains("初一"){
            return  (string.components(separatedBy: "年").last?.replacingOccurrences(of: "初一", with: "") ?? "",UIColor.red,calendarLayout.unSelectItemTitleColor!)
        }
        
        if indexPath.row % 7 == 0 || indexPath.row % 7 == 6 {
            return (string.components(separatedBy: "月").last ?? "" , calendarLayout.unSelectItemLunarTitleColor!,calendarLayout.weekendColor!)
        }
        
        return (string.components(separatedBy: "月").last ?? "" , calendarLayout.unSelectItemLunarTitleColor!,calendarLayout.unSelectItemTitleColor!)
    }
  
    
    /// 获取指定日期所在月份的第一天是星期几
     public func getFirstDayInDateMonth(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        var specifiedDateCom = calendar.dateComponents([.year,.month], from: date)
        specifiedDateCom.setValue(1, for: .day)
        let startOfMonth = calendar.date(from: specifiedDateCom)
        let weekDayCom = calendar.component(.weekday, from: startOfMonth!)
        return weekDayCom
    }
    
    func solarToLunar( day: Int) -> String {
        //初始化公历日历
        let solarCalendar = Calendar.init(identifier: .gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone.init(secondsFromGMT: 60 * 60 * 8)
        let solarDate = solarCalendar.date(from: components)
        
        //初始化农历日历
        let lunarCalendar = Calendar.init(identifier: .chinese)
        //日期格式和输出
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.calendar = lunarCalendar
        return formatter.string(from: solarDate!)
    }
    
    func solarToLunar( date: Date) -> String {
//   
//        let solarDate = solarCalendar.date(from: date)
//        
        //初始化农历日历
        let lunarCalendar = Calendar.init(identifier: .chinese)
        //日期格式和输出
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.calendar = lunarCalendar
        return formatter.string(from: date)
    }
}
