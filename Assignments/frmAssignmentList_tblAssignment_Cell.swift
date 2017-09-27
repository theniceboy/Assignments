//
//  frmAsignmentList_tblAssignmentListCell.swift
//  Assignments
//
//  Created by David Chen on 8/31/17.
//  Copyright © 2017 David Chen. All rights reserved.
//

import UIKit

class frmAsignmentList_tblAssignmentListCell: UITableViewCell {
    
    // MAKR: - Outlets
    
    @IBOutlet weak var vMaster: UIView!
    @IBOutlet weak var vSubject: UIView!
    @IBOutlet weak var vSubjectBlockingArea: UIView!
    @IBOutlet weak var lbSubject: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPriority: UILabel!
    @IBOutlet weak var vChecked: UIView!
    @IBOutlet weak var lbSectionHeader: UILabel!
    @IBOutlet weak var lbDueTime: UILabel!
    @IBOutlet weak var btnSegue: ZFRippleButton!
    @IBOutlet weak var vNewFromFocus: UIView!
    
    @IBOutlet weak var _layout_vMasterTopMargin: NSLayoutConstraint!
    @IBOutlet weak var _layout_vMasterHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var _layout_lbPriorityWidth: NSLayoutConstraint!
    
    // MARK: - UI
    
    var subjectUIColor: UIColor = UIColor.gray
    var cChecked: M13Checkbox = M13Checkbox()
    var rowNumber: Int = 0
    var assignmentRow: Int = 0
    var priorityStr: [String] = ["", "!", "!!", "!!!"]
    
    // MARK: - Functions
    
    func onSameDay (date1: Date, date2: Date) -> Bool {
        return (date1.year == date2.year && date1.month == date2.month && date1.day == date2.day)
    }
    
    
    // MARK: - Load
    
    func showSectionHeader () {
        //UIView.animate(withDuration: 0.1) {
            self._layout_vMasterHeightAnchor.constant = 134
            self._layout_vMasterTopMargin.constant = 36
            self.lbSectionHeader.alpha = 1.0
            self.layoutIfNeeded()
        //}
        
        if (tableAssignmentList[rowNumber].checked) {
            lbSectionHeader.text = "Completed"
            lbSectionHeader.textColor = UIColor.gray
            return
        }
        
        var assignmentCounter: Int = 1
        if (rowNumber < tableAssignmentList.count - 1) {
            while (onSameDay(date1: tableAssignmentList[rowNumber + assignmentCounter - 1].dueDate, date2: tableAssignmentList[rowNumber + assignmentCounter].dueDate) && !tableAssignmentList[rowNumber + assignmentCounter].checked) {
                assignmentCounter += 1
                if (rowNumber + assignmentCounter >= tableAssignmentList.count) {
                    break
                }
            }
        }
        lbSectionHeader.text = "\(assignmentCounter) Assignment" + (assignmentCounter > 1 ? "s" : "") + " Due " + (abs(daysDifference(date1: localDate(), date2: tableAssignmentList[rowNumber].dueDate)) > 1 ? "on " : "") + dateFormat_Word(date: tableAssignmentList[rowNumber].dueDate)
        if (tableAssignmentList[rowNumber].dueDate < localDate()) {
            lbSectionHeader.textColor = redColor
        } else {
            lbSectionHeader.textColor = themeColor
        }
    }
    
    func hideSectionHeader () {
        //UIView.animate(withDuration: 0.1) {
            self._layout_vMasterHeightAnchor.constant = 100
            self._layout_vMasterTopMargin.constant = 2
            self.lbSectionHeader.alpha = 0.0
            self.layoutIfNeeded()
        //}
    }
    
    let priorityXPosition: [CGFloat] = [0, 15, 20, 25]
    
    func showNewIndicator (new: Bool) {
        vNewFromFocus.backgroundColor = new ? UIColor.orange : UIColor.clear
    }
    
    func shouldShowSectionHeader () -> Bool {
        if (rowNumber == 0) {
            return true
        }
        if (rowNumber == uncheckedTableAssignmentCount) {
            return true
        }
        if (!onSameDay(date1: tableAssignmentList[rowNumber - 1].dueDate, date2: tableAssignmentList[rowNumber].dueDate)) {
            return true
        }
        return false
    }
    
    func loadCell() {
        
        // Set Cell UI
        
        if (shouldShowSectionHeader()) {
            showSectionHeader()
        } else {
            hideSectionHeader()
        }
        
        assignmentRow = getRowNum_AssignmentList(id: tableAssignmentList[rowNumber].id)
        
        lbPriority.text = priorityStr[tableAssignmentList[rowNumber].priority]
        _layout_lbPriorityWidth.constant = priorityXPosition[tableAssignmentList[rowNumber].priority]
        self.layoutIfNeeded()
        
        subjectUIColor = subjectColor(string: tableAssignmentList[rowNumber].subject)
        
        vMaster.layer.shadowColor = UIColor.black.cgColor
        vMaster.layer.shadowOffset = CGSize.zero
        vMaster.layer.shadowOpacity = 0.1
        vMaster.layer.shadowRadius = 5
        vMaster.layer.cornerRadius = 10
        
        vNewFromFocus.layer.cornerRadius = 8
        vNewFromFocus.layer.shadowColor = UIColor.black.cgColor
        vNewFromFocus.layer.shadowOffset = CGSize.zero
        vNewFromFocus.layer.shadowOpacity = 0.3
        vNewFromFocus.layer.shadowRadius = 2
        showNewIndicator(new: tableAssignmentList[rowNumber].newFromFocus)
        
        vSubject.layer.cornerRadius = 10
        
        lbTitle.tag = rowNumber
        lbTitle.text = tableAssignmentList[rowNumber].title
        lbSubject.text = tableAssignmentList[rowNumber].subject
        var duetime: String = "At "// + (tableAssignmentList[rowNumber].dueDate.minute < 10 ? " " : "") + "\(tableAssignmentList[rowNumber].dueDate.hour):" + (tableAssignmentList[rowNumber].dueDate.minute < 10 ? "0" : "") + "\(tableAssignmentList[rowNumber].dueDate.minute)"
        duetime = duetime + displayTime(date: tableAssignmentList[rowNumber].dueDate)
        if (tableAssignmentList[rowNumber].checked) {
            lbDueTime.text = "Due " + (daysDifference(date1: localDate(), date2: tableAssignmentList[rowNumber].dueDate) > 1 ? "On " : "") + dateFormat_Word(date: tableAssignmentList[rowNumber].dueDate) + " " + duetime
        } else {
            lbDueTime.text = "Due " + duetime
        }
        if (tableAssignmentList[rowNumber].dueDate.timeIntervalSince1970 < localDate().timeIntervalSince1970) {
            lbDueTime.textColor = redColor
        } else {
            lbDueTime.textColor = scrollGray
        }
        
        cChecked = M13Checkbox(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cChecked.stateChangeAnimation = .expand(.fill)
        cChecked.boxType = .square
        cChecked.cornerRadius = 4
        cChecked.animationDuration = 0.2
        for subview in vChecked.subviews {
            subview.removeFromSuperview()
        }
        vChecked.addSubview(cChecked)
        if (assignmentList[assignmentRow].checked) {
            cChecked.toggleCheckState(true)
            setCheckStateUI(checked: true)
        } else {
            cChecked.checkState = M13Checkbox.CheckState.unchecked
            setCheckStateUI(checked: false)
        }
        
        vSubject.backgroundColor = subjectUIColor
        cChecked.tintColor = subjectUIColor
        
        lbSubject.textColor = subjectUIColor
        lbSubject.layer.shadowColor = UIColor.darkGray.cgColor
        lbSubject.layer.shadowOffset = CGSize.zero
        lbSubject.layer.shadowRadius = 0.5
        lbSubject.layer.shadowOpacity = 0.2
        //lbSubject.
        
        btnSegue.rippleColor = subjectUIColor.withAlphaComponent(0.3)
        btnSegue.rippleBackgroundColor = UIColor.white.withAlphaComponent(0)
    }
    
    func setCheckStateUI (checked: Bool) {
        if (checked) {
            UIView.animate(withDuration: 0.3, animations: {
                self.vSubjectBlockingArea.backgroundColor = self.subjectUIColor.withAlphaComponent(0.2)
                self.vMaster.backgroundColor = self.subjectUIColor.withAlphaComponent(0.1)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.vSubjectBlockingArea.backgroundColor = UIColor.white
                self.vMaster.backgroundColor = UIColor.white
            })
        }
    }
    
    @IBAction func btnCheck_Tapped(_ sender: Any) {
        
        cChecked.toggleCheckState(true)
        
        if (cChecked.checkState == M13Checkbox.CheckState.checked) {
            assignmentList[assignmentRow].checked = true
            for item in UIApplication.shared.scheduledLocalNotifications! {
                if (item.userInfo!["id"] as! Int == assignmentList[assignmentRow].id) {
                    UIApplication.shared.cancelLocalNotification(item)
                    break
                }
            }
        } else {
            assignmentList[assignmentRow].checked = false
            if (assignmentList[assignmentRow].notificationOn) {
                var notifyDateTime = Date(), tmpDueDate = assignmentList[assignmentRow].dueDate
                if (abs(daysDifference(date1: localDate(), date2: tmpDueDate)) > 0) {
                    notifyDateTime = tmpDueDate.addingTimeInterval(-86400)
                    notifyDateTime = Date(year: notifyDateTime.year, month: notifyDateTime.month, day: notifyDateTime.day, hour: userSettings.defaultPushNotificationTime_hour, minute: userSettings.defaultPushNotificationTime_minute, second: 0)
                    
                    //printDate(date: notifyDateTime)
                } else {
                    notifyDateTime = Date(year: tmpDueDate.year, month: tmpDueDate.month, day: tmpDueDate.day, hour: userSettings.defaultPushNotificationTime_hour, minute: userSettings.defaultPushNotificationTime_minute, second: 0)
                    
                    if (!(localDate() < notifyDateTime && notifyDateTime < tmpDueDate)) {
                        notifyDateTime = Date(year: tmpDueDate.year, month: tmpDueDate.month, day: tmpDueDate.day, hour: (localDate().hour + tmpDueDate.hour) / 2, minute: 30, second: 0)
                    }
                }
                let notification = UILocalNotification()
                notification.fireDate = notifyDateTime
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.userInfo = ["id": assignmentList[assignmentRow].id]
                notification.alertBody = "[" + assignmentList[assignmentRow].subject + "] " + assignmentList[assignmentRow].title
                UIApplication.shared.scheduleLocalNotification(notification)
            }
            
        }
        assignmentList[assignmentRow].checkedDate = Date()
        saveAssignmentList()
        
        setCheckStateUI(checked: assignmentList[assignmentRow].checked)
        
        if (curFrmAssignmentList.showingChecked) {
            let assignmentID = tableAssignmentList[rowNumber].id
            var targetRow: Int = 0
            curFrmAssignmentList.formatTableData()
            for i: Int in 0 ... (tableAssignmentList.count - 1) {
                if (assignmentID == tableAssignmentList[i].id) {
                    targetRow = i
                    break
                }
            }
            if (rowNumber == tableAssignmentListDivider || rowNumber == tableAssignmentListDivider - 1) {
                
                curFrmAssignmentList.tblAssignmentList.moveRow(at: IndexPath(row: self.rowNumber, section: 0), to: IndexPath(row: targetRow, section: 0))
                //DispatchQueue.main.async {
                    curFrmAssignmentList.refreshTableAssignmentList(formatTable: false)
                //}
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                    curFrmAssignmentList.tblAssignmentList.moveRow(at: IndexPath(row: self.rowNumber, section: 0), to: IndexPath(row: targetRow, section: 0))
                })
                let when = DispatchTime.now() + 0.4
                DispatchQueue.main.asyncAfter(deadline: when) {
                    curFrmAssignmentList.refreshTableAssignmentList(formatTable: false)
                }
            }
            
            
            (curFrmAssignmentList.tblAssignmentList.cellForRow(at: IndexPath(row: rowNumber, section: 0)) as! frmAsignmentList_tblAssignmentListCell).loadCell()
        } else {
            /*
            if (rowNumber < tableAssignmentListDivider) {
                tableAssignmentList.remove(at: rowNumber)
                UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                    curFrmAssignmentList.tblAssignmentList.deleteRows(at: [IndexPath(row: self.rowNumber, section: 0)], with: UITableViewRowAnimation.right)
                })
                let when = DispatchTime.now() + 0.3
                DispatchQueue.main.asyncAfter(deadline: when) {
                    curFrmAssignmentList.refreshTableAssignmentList()
                }
            } else {
                
            }
 */
        }
    }
    
    @IBAction func btnSegue_Tapped(_ sender: Any) {
        curFrmAssignmentList.editAssignment(id: tableAssignmentList[rowNumber].id)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

