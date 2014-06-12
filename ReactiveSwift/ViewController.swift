//
//  ViewController.swift
//  ReactiveSwift
//
//  Created by Yusef Napora on 6/10/14.
//  Copyright (c) 2014 Yusef Napora. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var usernameField : UITextField!
    @IBOutlet var passwordField : UITextField!
    @IBOutlet var loginButton : UIButton!
    @IBOutlet var signInFailureText : UILabel!
    
    var signInService = DummySignInService()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // we can map signals using the trailing closure syntax
        var validUsernameSignal = usernameField.rac_textSignal().map { self.isValidUsername($0) }
        
        // or by passing the name of a function.
        // note that isValidPassword has to accept AnyObject! and return an AnyObject compatible type
        var validPasswordSignal = passwordField.rac_textSignal().map(isValidPassword)

        // Here we're using our swift version of the 'RAC' macro.
        // Using the custom operators '<~' and '~>', we can have the signal
        // on either side of the RAC construct.  Both of the following statements
        // wire up a signal to the 'backgroundColor' property of a UITextField
        

        RAC(self.usernameField, "backgroundColor") <~ validUsernameSignal.map(colorForValidity)
        validPasswordSignal.map(colorForValidity) ~> RAC(self.passwordField, "backgroundColor")
    
        // RACSignal prodvides a combineLatest:reduce: function that lets you provide a reducer block to
        // "sum up" multiple values.  However, it's implemented using a tricky feature of Objective C blocks
        // that is incompatibile with swift.  Namely, if you define an Objective C block type with an empty argument
        // list, it can accept any number of arguments.  
        // For example a block defined like this: id (^blockname)()
        // could be assigned a block with any number of parameters, so long as it returns id
        //
        // ReactiveCocoa exploits this to provide a limited form of dynamic blocks.  If a signal's value is an RACTuple,
        // it will invoke the block with the number of arguments corresponding to the number of values in the tuple.
        //
        // Swift is much more strict, and won't let you pass in a closure with arguments to a method expecting
        // a block with zero arguments.
        //
        // However, swift does provide a reduce function on the Array type, and we can easily get an Array
        // representation of an RACTuple's values.
        // Here we're mapping the RACTuple returned by RACSignal.combineLatest() to a single Bool, by first
        // casting tuple.allObjects() to a Bool[] and then reducing it using a very simple reducer that just
        // returns the logical AND of the two arguments.
        //
        // In a way this is more flexible, in that you can change the number of arguments to combineLatest: without
        // changing the implementation of the reduce closure.  However, it's also *less* flexible, in that all the
        // signals values must have the same type if you want to use Swift's reduce() function.
        // If you had signals of different value types, you could still unpack the RACTuple into its constituent values
        // by hand and apply your own logic.
        //
        let signupActiveSignal =  RACSignal.combineLatest([validUsernameSignal, validPasswordSignal]).AND()
        
        signupActiveSignal ~> RAC(self.loginButton, "enabled")
        
        loginButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .doNext {
                _ in
                self.loginButton.enabled = false
                self.signInFailureText.hidden = true
            }
            .flattenMap(signInSignal)
            .subscribeNext {
                let success = $0 as Bool
                self.loginButton.enabled = true
                self.signInFailureText.hidden = success
                println("Sign in result: \(success)")
                if success {
                    self.performSegueWithIdentifier("signInSuccess", sender: self)
                }
            }
    }

    func isValidUsername(name : AnyObject!) -> NSNumber! {
        return (name as NSString).length > 3;
    }
    
    // since we're passing this directly to a method expecting a block of type id (^)(id),
    // we need to accept and return AnyObject compatible types
    func isValidPassword(pass : AnyObject!) -> NSNumber! {
        return (pass as NSString).length > 3;
    }
    
    func colorForValidity(valid : AnyObject!) -> UIColor! {
        return (valid as Bool) ? UIColor.clearColor() : UIColor.yellowColor()
    }
    
    func signInSignal(_ : AnyObject!) -> RACSignal {
        return RACSignal.createSignal {
            subscriber in
            self.signInService.signIn(self.usernameField.text, password: self.passwordField.text) {
                subscriber.sendNext($0)
                subscriber.sendCompleted()
            }
            return nil
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

