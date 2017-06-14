//
//  LoginVC.swift
//  ReaddleInternshipTest
//
//  Created by  Tim on 13.06.17.
//  Copyright © 2017  Tim. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class LoginVC: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    private let scopes = [kGTLRAuthScopeDriveReadonly, kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    private let service = GTLRSheetsService()
    private let weekDays = ["'Воскресенье'", "'Понедельник'", "'Вторник'", "'Среда '", "'Четверг'", "'Пятница'", "'Суббота'"]
    private var usersList: [String]! = []
    private var dishes: [String]! = []
    private var dishesForToday: [String]! = []
    private var currentUser: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        
        if error != nil {
            print(error!)
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        
        
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        signInButton.center = view.center
        
        view.addSubview(signInButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodTableVC" {
            if let FoodTableVC = segue.destination as? FoodTableVC {
                if let dishes = sender as? [String] {
                    FoodTableVC.dishesForToday = dishes
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        self.service.authorizer = user.authentication.fetcherAuthorizer()
        
        //listTodayDishes()
        //getUsersList()
        
        let alert = UIAlertController(title: "", message: "Enter your name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0] {
                if let name = textField.text {
                       /* if self.usersList.contains(name){
                            if let index = self.usersList.index(of: name) {
                                //self.userChoiseForToday(index: index+1)
                                //self.performSegue(withIdentifier: "FoodTableVC", sender: self.dishesForToday)
                            }
                            
                        } else {
                            self.present(alert!, animated: true, completion: nil)
                        }*/
                    self.currentUser = name
                    self.getUsersList()
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        //listTodayDishes()
        //userChoiseForToday(index: 5)
    }
    
    func listTodayDishes() {
        let spreadsheetId = SPREADSHEET_ID
        let currentDayOfWeek = Date().dayNumberOfWeek()!-1
        let range = "\(weekDays[currentDayOfWeek])!B2:M2"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        query.majorDimension = "COLUMNS"
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicketDishes(ticket:finishedWithObject:error:))
        )
    }
    
    func getUsersList() {
        let spreadsheetId = "1NrPDjp80_7venKB0OsIqZLrq47jbx9c-lrWILYJPS88"
        let currentDayOfWeek = Date().dayNumberOfWeek()!-1
        let range = "\(weekDays[currentDayOfWeek])!A:B"
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
        let range = "\(weekDays[currentDayOfWeek])!B2:M\(index)"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        query.majorDimension = "ROWS"
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicketChoise(ticket:finishedWithObject:error:))
        )
    }
    
    // Process the response and display output
    func displayResultWithTicket(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRSheets_ValueRange,
                                 error : NSError?){
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        let rows = result.values!
        
        if rows.isEmpty {
            print("No data found.")
            return
        }
        
        var name = ""
        for (index, row) in rows.enumerated() {
            if row.count > 0 {
                name = row[0] as! String
                if name == currentUser {
                    userChoiseForToday(index: index+1)
                }
            } else {
                name = "0"
            }
        
            usersList.append(name)
        }
        print(usersList)
        
    }
    func displayResultWithTicketDishes(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRSheets_ValueRange,
                                 error : NSError?){
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        let rows = result.values!
        
        if rows.isEmpty {
            print("No data found.")
            return
        }
        
        var dish = ""
        for row in rows {
            dish = row[0] as! String
            dishes.append(dish)
        }
        print (dishes)
        
    }
    
    func displayResultWithTicketChoise(ticket: GTLRServiceTicket,
                                       finishedWithObject result : GTLRSheets_ValueRange,
                                       error : NSError?){
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        let rows = result.values!
        
        if rows.isEmpty {
            print("No data found.")
            return
        }
        
        //var choise = ""
        //var dish = ""
        //print (rows)
        var dishes: [String] = rows[0] as! [String]
        let choises: [String] = rows [rows.count-1] as! [String]
        for (index, choise) in choises.enumerated() {
            if choise == "1" {
                dishesForToday.append(dishes[index])
            }
        }
        print (dishesForToday)
        performSegue(withIdentifier: "FoodTableVC", sender: dishesForToday)
        
    }
    
    
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

