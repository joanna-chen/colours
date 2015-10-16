//
//  SecondViewController.swift
//  The Big Mysterious App
//
//  Created by Joanna Chen on 2015-08-28.
//  Copyright (c) 2015 Jocular Cows Inc. All rights reserved.
//

import UIKit
import GameKit

class SecondViewController: UIViewController, GKGameCenterControllerDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    var scorePrinted: Int = 0
    var highScoreDefaultSync: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    var highScorePrintedSync: Int = 0
    
    @IBOutlet weak var buttonExit: UIButton!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet var leaderboard: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (highScoreDefaultSync.valueForKey("Highscore") != nil) && (highScoreDefaultSync.valueForKey("Highscore") as! NSInteger > scorePrinted) {
 
            highScore.text = "high score: " + String(highScorePrintedSync)
            
        } else {

            highScore.text = "high score: " + String(scorePrinted)
            
        }
        
        currentScore.text = "score: " + String(scorePrinted)
        
    }
    
    //shows leaderboard screen
    func showLeader() {
        var vc = self.view.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        self.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leaderboardAction(sender: AnyObject) {
        showLeader()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
