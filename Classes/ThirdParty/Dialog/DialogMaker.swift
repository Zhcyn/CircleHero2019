//
//  DialogMaker.swift
//  KeepRhythm
//
//  Created by Sroik on 9/22/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import UIKit

private let kDaysPerRate: Int = 10

let IsRatedKey = "app_is_rated"
let RateURL: URL = URL(string: "https://itunes.apple.com/us/app/id1042547779")!

class DialogMaker {

    class func showRateDialogIfNeed() {
        if UserDefaults.standard.bool(forKey: IsRatedKey) == true {
            return
        }
        
        let rootController = UIApplication.shared.delegate?.window??.rootViewController
        
        let alertController = UIAlertController(title: "Please Rate", message: "Do you like Circle Hero?", preferredStyle: .alert)
        
        let rateAction = UIAlertAction(title: "RATE", style: .default, handler: {(action: UIAlertAction) -> Void in
            UserDefaults.standard.set(true, forKey: IsRatedKey)
            UIApplication.shared.openURL(RateURL)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(rateAction)
        alertController.addAction(cancelAction)
        
        var counter = UserDefaults.standard.integer(forKey: "rate_dialog_key")
        counter += 1
        UserDefaults.standard.set(counter, forKey:"rate_dialog_key")
        
        if (counter%kDaysPerRate == 0) {
            rootController?.present(alertController, animated: true, completion: nil)
        }
    }
    
}
