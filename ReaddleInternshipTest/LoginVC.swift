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
import CoreData

class LoginVC: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    private let scopes = [kGTLRAuthScopeDriveReadonly, kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    private let service = GTLRSheetsService()
    private var currentUser: User?
    private var usersList: [String] = []

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
    
    func getUsersList() {
        let spreadsheetId = SPREADSHEET_ID
        let range = "A3:B"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
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
        for row in rows {
            if row.count > 0 {
                name = row[0] as! String
                usersList.append(name)
            }
        }
        print(usersList)
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


    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }

        self.service.authorizer = user.authentication.fetcherAuthorizer()
        
        getUsersList()
        
        let alert = UIAlertController(title: "", message: "Как тебя зовут?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0] {
                if let name = textField.text, textField.text != "", self.usersList.contains(textField.text!) {
                    let dataName = User(context: context)
                    dataName.name = name
                    ad.saveContext()
                    NotificationCenter.default.post(
                        name: Notification.Name(rawValue: "ServiceSpreadsheet"),
                        object: user.authentication.fetcherAuthorizer(),
                        userInfo: ["currentUser":name])
                } else {
                    self.present(alert!, animated: true, completion: nil)
                }
            }
        }))
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            let savedName = try context.fetch(fetchRequest)
            if let fetchedName = savedName.first?.name{
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "ServiceSpreadsheet"),
                    object: user.authentication.fetcherAuthorizer(),
                    userInfo: ["currentUser":fetchedName])
            } else {
                self.present(alert, animated: true, completion: nil)

            }
        } catch {
        
        }
        

    }
    
}

