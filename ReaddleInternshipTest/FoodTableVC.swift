//
//  FoodTableVC.swift
//  ReaddleInternshipTest
//
//  Created by  Tim on 13.06.17.
//  Copyright © 2017  Tim. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class FoodTableVC: UIViewController{
    //@IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var output: UITextView!
    
    var dishesForToday: [String]! = []
    private let weekDays = ["'Воскресенье'", "'Понедельник'", "'Вторник'", "'Среда'", "'Четверг'", "'Пятница'", "'Суббота'"]
    private let service = GTLRSheetsService()
    private var choiseForWeek: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collection.delegate = self
        //collection.dataSource = self
        
        print(dishesForToday)
        //GIDSignIn.sharedInstance().signInSilently()
        
        
        for str in dishesForToday {
            output.text.append("\(str)\n")
        }
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
