//
//  FoodTableVC.swift
//  ReaddleInternshipTest
//
//  Created by  Tim on 13.06.17.
//  Copyright © 2017  Tim. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class FoodTableVC: UIViewController, GIDSignInUIDelegate{
    //@IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var output: UITextView!
    @IBOutlet weak var statusText: UILabel!
    
    
    var dishesForToday: [String]! = []
    private let weekDays = ["'Воскресенье'", "'Понедельник'", "'Вторник'", "'Среда '", "'Четверг'", "'Пятница'", "'Суббота'"]
    private let service = GTLRSheetsService()
    private var choiseForWeek: [String] = []
    var currentUser: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleAuthUI()
        GIDSignIn.sharedInstance().uiDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FoodTableVC.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ServiceSpreadsheet"),
                                               object: service.authorizer)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        toggleAuthUI()
    }
    
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            dismiss(animated: true, completion: nil)
            getUsersList()            
        } else {
            performSegue(withIdentifier: "LoginVC", sender: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ServiceSpreadsheet"),
                                                  object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ServiceSpreadsheet" {
            service.authorizer=notification.object as? GTMFetcherAuthorizationProtocol
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                self.statusText.text = userInfo["statusText"]!
                self.currentUser = userInfo["currentUser"]!
            }
        }
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
        
        var dishes: [String] = rows[0] as! [String]
        let choises: [String] = rows [rows.count-1] as! [String]
        for (index, choise) in choises.enumerated() {
            if choise == "1" {
                dishesForToday.append(dishes[index])
                output.text.append(dishes[index])
            }
        }
        //print (dishesForToday)
    }

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
                if name == self.currentUser {
                    userChoiseForToday(index: index+1)
                }
            } else {
                name = "0"
            }
        }        
    }

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
