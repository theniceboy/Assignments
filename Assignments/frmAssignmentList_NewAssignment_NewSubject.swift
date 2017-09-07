//
//  frmAssignmentList_NewAssignment_NewSubject.swift
//  Assignments
//
//  Created by David Chen on 9/3/17.
//  Copyright © 2017 David Chen. All rights reserved.
//

import UIKit

class frmAssignmentList_NewAssignment_NewSubject: UIViewController {
    
    @IBOutlet weak var tfName: SkyFloatingLabelTextField!
    @IBOutlet weak var btnAdd: ZFRippleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curFrmAssignmentList_NewAssignment_NewSubject = self
        
        initializeUI()
    }
    
    func initializeUI () {
        
        tfName.text = ""
        tfName.errorMessage = ""
        
        tfName.becomeFirstResponder()
    }

    @IBAction func tfName_EditingChanged(_ sender: Any) {
        if (tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
            tfName.errorMessage = ""
        }
    }
    
    @IBAction func btnCancel_Tapped(_ sender: Any) {
        self.dismiss(animated: true) { }
    }
    
    func cgfloatABS (value: CGFloat) -> CGFloat {
        return (value < 0 ? -value : value)
    }
    
    @IBAction func btnAdd_Tapped(_ sender: Any) {
        let name = (tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        if (name == "") {
            tfName.errorMessage = "The name of the subject cannot be empty"
            return
        }
        for item in subjectList {
            if (name == item.name) {
                tfName.errorMessage = "The subject \"" + name + "\" already exists"
                return
            }
        }
        let newSubjectItem: SubjectItem = SubjectItem()
        newSubjectItem.name = name
        var colorOK: Bool = false, newColor: UIColor = UIColor.white
        var firstR: CGFloat = 0, secondR: CGFloat = 0
        var firstG: CGFloat = 0, secondG: CGFloat = 0
        var firstB: CGFloat = 0, secondB: CGFloat = 0
        var firstAlpha: CGFloat = 0, secondAlpha: CGFloat = 0
        for _ in 0 ... 10000 {
            newColor = randomColor(hue: Hue.random, luminosity: Luminosity.light)
            colorOK = true
            for item in subjectList {
                newColor.getRed(&firstR, green: &firstG, blue: &firstB, alpha: &firstAlpha)
                if (firstR + firstG + firstB > 2) {
                    colorOK = false
                    break
                }
                item.color.getRed(&secondR, green: &secondG, blue: &secondB, alpha: &secondAlpha)
                if (cgfloatABS(value: (firstR - secondR)) +
                    cgfloatABS(value: (firstG - secondG)) +
                    cgfloatABS(value: (firstB - secondB)) < 0.3) {
                    colorOK = false
                    break
                }
            }
            if (colorOK) {
                break
            }
        }
        newSubjectItem.color = newColor
        subjectList.append(newSubjectItem)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addedSubject"), object: nil)
        saveSubjectList()
        self.dismiss(animated: true, completion: {
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}