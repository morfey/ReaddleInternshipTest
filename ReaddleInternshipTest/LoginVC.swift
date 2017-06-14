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

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        let alert = UIAlertController(title: "", message: "Как тебя зовут?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0] {
                if let name = textField.text {
                    let dataName = User(context: context)
                    dataName.name = name
                    ad.saveContext()
                    NotificationCenter.default.post(
                        name: Notification.Name(rawValue: "ServiceSpreadsheet"),
                        object: user.authentication.fetcherAuthorizer(),
                        userInfo: ["currentUser":name])
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

