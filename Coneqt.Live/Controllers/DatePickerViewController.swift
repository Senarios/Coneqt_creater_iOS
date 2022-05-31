//
//  DatePickerViewController.swift
//  Coneqt.Live
//
//  Created by Senarios on 31/01/2022.
//

import UIKit
import FSCalendar

class DatePickerViewController: UIViewController{

    @IBOutlet weak var btnDismiss : UIButton!
    @IBOutlet weak var txtHour : UITextField!
    @IBOutlet weak var txtMinutes : UITextField!
    @IBOutlet weak var calender: FSCalendar!
    
    @IBOutlet weak var segment: UISegmentedControl!
    var selectedDate : String?
    var isAmOrPm = "AM"
    let formatter = DateFormatter()
    var onCompletion : ((String) -> Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calender.delegate = self
        calender.dataSource = self
        calender.formatter.timeZone = .current
        calender.select(Date())
        
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = Date().toString(dateFormatter: formatter)
        txtMinutes.delegate = self
        txtHour.delegate = self
        txtHour.keyboardType = .numberPad
        txtMinutes.keyboardType = .numberPad
      
        
        calender.appearance.headerTitleColor = .black
        calender.appearance.headerTitleFont = Fonts.get(type: .Montserrat_Semibold, size: 17)

        /// no effect
        calender.appearance.titleDefaultColor = .black
        
        calender.appearance.weekdayTextColor = .black
        calender.appearance.weekdayFont = Fonts.get(type: .Montserrat_Regular, size: 12)
        
        btnDismiss.setTitle("", for: .normal)
        let dismissImage = SVGKImage(named: "multiply").uiImage
        btnDismiss.setImage(dismissImage, for: .normal)
        
        let date = Date()
        let calender = Calendar.current

        let requestComponents : Set<Calendar.Component> = [
            .hour,
            .minute,
        ]
        let components = calender.dateComponents(requestComponents, from: date)
        let timeString = "\(components.hour):\(components.hour) "
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let d12 = dateFormatter.date(from: timeString)
        print("time string is",timeString)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 15, to: today)
        return nextDate!
    }

    @IBAction func didTapDismissButton(_ sender : UIButton){
        
        dismiss(animated: true)
        
    }
  
    @IBAction func didTapSaveDate(_ sender : UIButton){
        
        
        if selectedDate == nil{
            Toast.show(message: "Please Select date ", controller: self)
        }else if txtHour.text!.count == 0 || txtMinutes.text!.count == 0 {
            Toast.show(message: "Please Select time", controller: self)
        }else{
            print("Selected date is",selectedDate)
            if isAmOrPm == "PM"{
                // add 12 in am time
                print(txtHour.text,isAmOrPm)
              
                if let hourInt = Int(txtHour.text!){
                    
                    if hourInt < 12{
                        print("hour int is come in less than 12",hourInt)
                       
                        let newTimeHour = hourInt+12
                            let newTimeHourStr = String(newTimeHour)
                        print("noew new time is",newTimeHourStr)
                            selectedDate!.append(" "+newTimeHourStr+":"+txtMinutes.text!)
                    }else{
                        print("come in else")
                        selectedDate!.append(" "+txtHour.text!+":"+txtMinutes.text!)
                    }

                }
          
                
                
            }else{
                print("come in time is in am")
                selectedDate!.append(" "+txtHour.text!+":"+txtMinutes.text!)
            }
            
            dismiss(animated: true) { [weak self] in
                self?.onCompletion?(self!.selectedDate!)
            }

        }
        
      
        
    }
  


    @IBAction func didTapSagment(_ sender: UISegmentedControl) {
        
        isAmOrPm = sender.selectedSegmentIndex == 0 ? "AM" : "PM"
    }
    
}


extension DatePickerViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField{
        case txtMinutes:
            if txtHour.text!.count < 3 && Int(txtHour.text!) ?? 14 < 13{
                return true
            }else{
                return false
            }
        default:
            return true
        }
    }
    
    
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        switch textField{

        case txtHour:
            
            if txtHour.text!.count == 2 && txtHour.text!.first!.asciiValue ?? 50 > 49{
//                txtHour.text!.first?.asciiValue ?? 54 > 53
                txtHour.text = Methods.shared.trimLast(to: 1, txtMinutes.text!)
             //   let char = Methods.shared.charAt(1, txtHour.text!)
             
                
            }
            
            if txtHour.text!.count == 2{
                    let char = Methods.shared.charAt(1, txtHour.text!)
                print("char asci value is",char?.asciiValue)
                if char?.asciiValue ?? 52 > 50{
                    txtHour.text = Methods.shared.trimLast(to: 1, txtMinutes.text!)
                }
//
            
             
                
            }
            
            if txtHour.text!.count > 2 {
                txtHour.text = Methods.shared.trimLast(to: 1, txtHour.text!)
            }
            
        case txtMinutes:
           
            if txtMinutes.text?.count == 1 && txtMinutes.text!.first?.asciiValue ?? 54 > 53 {
                txtMinutes.text = Methods.shared.trimLast(to: 1, txtMinutes.text!)
            }
            if txtMinutes.text!.count > 2{
                txtMinutes.text = Methods.shared.trimLast(to: 1, txtMinutes.text!)
            }
        default:
            print("nothing")
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField{
        case txtHour:
            if txtHour.text!.count < 3{
                txtMinutes.becomeFirstResponder()
                return true
            }else{
                return false
            }
        case txtMinutes:
            txtMinutes.resignFirstResponder()
            return true
        default:
            return true
        }

    }
}



extension DatePickerViewController : FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
     
        
        selectedDate = date.toString(dateFormatter: formatter)
         
    }
    
 
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .black
    }
    
  
}


