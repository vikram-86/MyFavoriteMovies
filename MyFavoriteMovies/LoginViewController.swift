//
//  ViewController.swift
//  MyFavoriteMovies
//
//  Created by Suthananth Arulanantham on 14.05.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    
    var tapRecognizer : UITapGestureRecognizer? = nil
    var keyboardActivated = false
    
    var appdelegate : AppDelegate!
    var session : NSURLSession!
    
    @IBAction func signInButtonTouchup() {
        self.view.endEditing(true)
        /*
        Steps for Authentication...
        https://www.themoviedb.org/documentation/api/sessions
        
        Step 1: Create a new request token
        Step 2: Ask the user for permission via the API ("login")
        Step 3: Create a session ID
        
        Extra Steps...
        Step 4: Go ahead and get the user id ;)
        Step 5: Got everything we need, go to the next view!
        
        */
        if userNameTextfield.text.isEmpty{
            self.debugLabel.text = "Username Empty"
            return
        }
        if passwordTextfield.text.isEmpty{
            self.debugLabel.text = "Password Empty"
            return
        }
        self.debugLabel.text = "Signing in .."
        self.getRequestToken()
    }
    
}

/* Stubs for controlling UI Problems */
extension LoginViewController{
    
    // hide keyboard when user touches return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // return height of keyboard
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //shift view back to normal when keyboard hides
    func keyboardWillHide(notification:NSNotification){
        self.view.superview?.frame.origin.y = 0
        
        
    }
    // shift view up when keyboard shows
    func keyboardWillShow(notification:NSNotification){
            self.view.superview?.frame.origin.y = 0 - self.getKeyboardHeight(notification)
        
        
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
}

/* UTILITY STUBS*/
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.session = NSURLSession.sharedSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        super.viewDidAppear(animated)
        self.subscribeToKeyboardNotifications()
        self.userNameTextfield.delegate = self
        self.passwordTextfield.delegate = self
        self.addTapRecognizer()
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
        self.removeTapRecognizer()
    }
    
    func handleSingleTap(recognizer : UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    func addTapRecognizer(){
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        self.tapRecognizer?.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    func removeTapRecognizer(){
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
}

