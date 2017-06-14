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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        
        if error != nil {
            print(error!)
            return
        }
        //collection.delegate = self
        //collection.dataSource = self
        
        //print(dishesForToday)
        //GIDSignIn.sharedInstance().signInSilently()
        //GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().uiDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FoodTableVC.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ServiceSpreadsheet"),
                                               object: service.authorizer)
        
        //statusText.text = "Initialized Swift app..."
        
        
        
        
        
        //for str in dishesForToday {
            //output.text.append("\(str)\n")
        //}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        toggleAuthUI()
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        toggleAuthUI()
    }
    @IBAction func didTapDisconnect(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().disconnect()
        statusText.text = "Disconnecting."
    }
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            //signInButton.isHidden = true
            //signOutButton.isHidden = false
            //disconnectButton.isHidden = false
            print ("OK have")
            dismiss(animated: true, completion: nil)
            getUsersList()
            
        } else {
            //signInButton.isHidden = false
            //signOutButton.isHidden = true
            //disconnectButton.isHidden = true
            statusText.text = "Google Sign in\niOS Demo"
            print ("not ok")
            performSegue(withIdentifier: "LoginVC", sender: nil)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
                //if name == currentUser {
                //    userChoiseForToday(index: index+1)
                //}
            } else {
                name = "0"
            }
            
            //usersList.append(name)
        }
        print(rows)
        
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
    
    /*func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? DayCell {
            cell.configureCell()
            return cell
        } else {
            return UICollectionViewCell()
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }*/

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
