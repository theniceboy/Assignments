//
//  Gib.swift
//  Assignments
//
//  Created by David Chen on 8/31/17.
//  Copyright © 2017 David Chen. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Global Variables

var assignmentList: [AssignmentItem] = []
var subjectList: [SubjectItem] = []

var myCalender: Calendar = Calendar.current

var __DEFAULT_SUBJECT_NAME = "General"

// MARK: - Live Viewcontrollers

var curFrmAssignmentList: frmAssignmentList = frmAssignmentList()
var curFrmAssignmentList_NewAssignment: frmAssignmentList_NewAssignment = frmAssignmentList_NewAssignment()
var curFrmAssignmentList_NewAssignment_NewSubject:frmAssignmentList_NewAssignment_NewSubject = frmAssignmentList_NewAssignment_NewSubject()

// MARK: - Colors

var themeColor = UIColor(red: 74.0 / 255.0, green: 144.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0) // Theme blue color
var redColor = UIColor(red: 208.0 / 255.0, green: 2.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0) // Theme red color

// MARK: - Hash for Date

let h_iday: [String: Int] = ["Monday": 1, "Tuesday": 2, "Wednesday": 3, "Thursday": 4, "Friday": 5, "Saturday": 6, "Sunday": 7]
let h_day: [Int: String] = [1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday", 7: "Sunday"]
let h_uday: [Int: String] = [-1: "yesterday", 0: "today", 1: "tomorrow"]
let h_week: [Int: String] = [0: "last ", 1: "", 2: "next "]

// MARK: - Global Functions

func weekOfYear (date: Date) -> Int {
    return myCalender.component(.weekOfYear, from: date)
}

func dayOfWeek (date: Date) -> Int {
    return date.weekday == 1 ? 7 : date.weekday - 1
}

func daysDifference (date1: Date, date2: Date) -> Int {
    // Replace the hour (time) of both dates with 00:00
    let date1 = myCalender.startOfDay(for: date1)
    let date2 = myCalender.startOfDay(for: date2)
    
    return myCalender.dateComponents([.day], from: date1, to: date2).day!
}

func dateFormat_Word (date: Date) -> String {
    let uday: Int = daysDifference(date1: Date.today(), date2: date)
    let nday = dayOfWeek(date: date)
    let formatter = DateFormatter()
    formatter.dateFormat = " (MM/dd)"
    //let advanced_str: String = (abs(uday) > 1 ? (uday > 1 ? "（\(uday) days later）" : "（\(abs(uday)) days ago）") : "")
    let advanced_str: String = " (\(date.month)/\(date.day))"
    if (abs(uday) > 14) {
        return "\(date.month)/\(date.day)/\(date.year)" + advanced_str
    }
    if (abs(uday) < 2) {
        return h_uday[uday]! + advanced_str
    } else if (weekOfYear(date: date) == weekOfYear(date: Date.today())) {
        return h_day[nday]! + advanced_str
    } else if (abs(weekOfYear(date: date) - weekOfYear(date: Date.today())) < 2) {
        var str: String = ""
        if (abs(uday) >= 7 || (uday > 0 && nday < dayOfWeek(date: Date.today())) || (uday < 0 && nday > dayOfWeek(date: Date.today()))) {
            str = ((uday > 0) ? h_week[2] : h_week[0])!
        }
        str += h_day[nday]!
        return str + advanced_str
    }
    return "\(date.month)/\(date.day)/\(date.year)" + advanced_str
}
