//
//  ViewController.swift
//  FacebookLogin2
//
//  Created by mrsic on 06/02/2020.
//  Copyright © 2020 Lorena Mrsic. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class ViewController: UIViewController {


    @IBOutlet weak var lblUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func loginFbTapped(_ sender: Any) {
        fbLogin()
    }
    func fbLogin(){
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [ .publicProfile, .email, .userFriends], viewController: self){ loginResult in
            switch loginResult{
            case .failed(let error):
                //HUD.hide()
                print(error)
            case .cancelled:
                //HUD.hide()
                print("User cancelled login.")
            case .success(_, _, _):
                print("Logged in!")
                self.getFBUserData()
                if (self.lblUserName.isHidden == true){
                    self.lblUserName.isHidden = false
                }
                else{
                    self.lblUserName.isHidden = true
                }
            }
        }
    }
    
    func getFBUserData() {
        if((AccessToken.current) != nil){
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let dict = result as! [String : AnyObject]
                    print(result!)
                    print(dict)
                    let picutreDic = dict as NSDictionary
                    let tmpURL1 = picutreDic.object(forKey: "picture") as! NSDictionary
                    let tmpURL2 = tmpURL1.object(forKey: "data") as! NSDictionary
                    let finalURL = tmpURL2.object(forKey: "url") as! String
                    
                    let nameOfUser = picutreDic.object(forKey: "name") as! String
                    self.lblUserName.text = "Hello "+nameOfUser
                    
                }
                print(error?.localizedDescription as Any)
            })
        }
    }
}

