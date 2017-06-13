//
//  ViewController.swift
//  ReaddleInternshipTest
//
//  Created by  Tim on 13.06.17.
//  Copyright © 2017  Tim. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    private let scopes = [kGTLRAuthScopeDriveReadonly, kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    private let service = GTLRSheetsService()
    private let weekDays = ["'Воскресенье'", "'Понедельник'", "'Вторник'", "'Среда'", "'Четверг'", "'Пятница'", "'Суббота'"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        
        if error != nil {
            print(error)
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        
        
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        signInButton.center = view.center
        
        view.addSubview(signInButton)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        self.service.authorizer = user.authentication.fetcherAuthorizer()
        //listTodayDishes()
        userChoiseForToday(index: 5)
        //getUsersList()
        //performSegue(withIdentifier: "FoodTableVC", sender: nil)
    }
    
    func listTodayDishes() {
        let spreadsheetId = "1NrPDjp80_7venKB0OsIqZLrq47jbx9c-lrWILYJPS88"
        let currentDayOfWeek = Date().dayNumberOfWeek()!-1
        let range = "\(weekDays[currentDayOfWeek])!B2:M2"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        query.majorDimension = "COLUMNS"
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    func getUsersList() {
        let spreadsheetId = "1NrPDjp80_7venKB0OsIqZLrq47jbx9c-lrWILYJPS88"
        let currentDayOfWeek = Date().dayNumberOfWeek()!-1
        let range = "\(weekDays[currentDayOfWeek])!A2:B"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    func userChoiseForToday(index: Int) {
        let spreadsheetId = "1NrPDjp80_7venKB0OsIqZLrq47jbx9c-lrWILYJPS88"
        let currentDayOfWeek = Date().dayNumberOfWeek()!-1
        let range = "\(weekDays[currentDayOfWeek])!B\(index):M\(index)"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        query.majorDimension = "COLUMNS"
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Process the response and display output
    func displayResultWithTicket(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRSheets_ValueRange,
                                 error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var majorsString = ""
        let rows = result.values!
        
        if rows.isEmpty {
            print("No data found.")
            return
        }
        
        majorsString += "Name, Major:\n"
        var name = ""
        for row in rows {
            if row.count > 0 {
                name = row[0] as! String
            } else {
                name = "0"
            }
            //let major = row[1]
            
            majorsString += "\(name)\n"
        }
        
        print (majorsString)
    }

//    func displayResultWithTicket(ticket: GTLRServiceTicket,
//                                 finishedWithObject result : GTLRSheets_ValueRange,
//                                 error : NSError?) {
//        
//        if let error = error {
//            showAlert(title: "Error", message: error.localizedDescription)
//            return
//        }
//        
//        var majorsString = ""
//        let rows = result.values!
//        
//        if rows.isEmpty {
//            print("No data found.")
//            return
//        }
//        
//        majorsString += "Name, Major:\n"
//        for (index, row) in rows.enumerated() {
//            let name = row[0]
//            if "\(name)" == "Боб Петтит" {
//                userChoiseForToday(index: index+2)
//            } else {
//                majorsString += "\(name)\n"
//            }
//            //let major = row[1]
//            
//            
//        }
//        
//        print (majorsString)
//    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

