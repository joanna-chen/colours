//
//  ViewController.swift
//  The Big Mysterious App
//
//  Created by Joanna Chen on 2015-08-26.
//  Copyright (c) 2015 Shi Lin Chen. All rights reserved.
//

import UIKit
import AVFoundation
import iAd
import GameKit

class ViewController: UIViewController, ADBannerViewDelegate {
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Here you can init your properties
    }
  
    var audioPlayer = AVAudioPlayer()
    var failPlayer = AVAudioPlayer()
    var score : Int = 0
    var timer : NSTimer = NSTimer()
    var timerSpeed = 5.0
    var highScorePrinted: Int = 0
    var highScoreDefault = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var adBannerView: ADBannerView?
    @IBOutlet weak var circle: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var buttonGameOver: UIButton!
    @IBOutlet weak var circularTimer: KDCircularProgress!
    @IBOutlet weak var instruction: UILabel!
    
    override func viewDidLoad() {
        authenticateLocalPlayer()
        instruction.hidden = true
        super.viewDidLoad()
        var scoreSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ding", ofType: "wav")!)
        randomBasicColors()
        startTimer()
        circle.layer.borderWidth = 5
        circle.layer.masksToBounds = true
        circle.layer.borderColor = UIColor.whiteColor().CGColor
        circle.layer.cornerRadius = circle.frame.height/2
        circle.clipsToBounds = true
        buttonGameOver.hidden = true
        button1.enabled = true
        button2.enabled = true
        button3.enabled = true
        button4.enabled = true
        circularTimer.angle = 0
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        //AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        //AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        //audioPlayer = AVAudioPlayer(contentsOfURL: scoreSound, fileTypeHint: nil)
        
        self.canDisplayBannerAds = true
        self.adBannerView?.delegate = self
        self.adBannerView?.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.adBannerView?.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func shuffleArray<T>(var array: [T]) -> [T] {
        for index in Array(0..<array.count) {
            let randomIndex = Int(arc4random_uniform(UInt32(index)))
            (array[index], array[randomIndex]) = (array[randomIndex], array[index])
        }
        return array
    }
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
                
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    func randomBasicColors() {
        let blue = UIColor(red: 0x66/255, green: 0x99/255, blue: 0xff/255, alpha: 1.0)
        let orange = UIColor(red: 0xff/255, green: 0xcc/255, blue: 0x66/255, alpha: 1.0)
        let pink = UIColor(red: 0xff/255, green: 0x99/255, blue: 0x99/255, alpha: 1.0)
        let green = UIColor(red: 0x75/255, green: 0xff/255, blue: 0xa3/255, alpha: 1.0)
        var basicColors = [blue, orange, pink, green]
        
        var randomNumber = [-1, 0, 1, 2, 3]
        randomNumber = shuffleArray(randomNumber)
        
        circle.backgroundColor = basicColors[randomNumber[0]]
        basicColors = shuffleArray(basicColors)
        button1.backgroundColor = basicColors[0]
        button2.backgroundColor = basicColors[1]
        button3.backgroundColor = basicColors[2]
        button4.backgroundColor = basicColors[3]
    }
    
    func startTimer() {
        if score >= 1 {
            instruction.hidden = true
        }
            timer = NSTimer.scheduledTimerWithTimeInterval(timerSpeed, target: self, selector: "gameOver", userInfo: nil, repeats: false)
            circularTimer.animateToAngle(360, duration: timerSpeed, completion: nil)
    }
    
    func resetTimer() {
        timer.invalidate()
        startTimer()
        circularTimer.angle = 0
    }
    
    //send high score to leaderboard
    func saveHighscore(x: Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "grp.ColoursLeaderbaord") //leaderboard id here
            
            scoreReporter.value = Int64(x) //score variable here (same as above)
            
            var scoreArray: [GKScore] = [scoreReporter]
            
           
            
        }
        
    }

    
    func gameOver() {
        if score < 1 {
            instruction.hidden = false
            resetTimer()
            
        } else {
            //go to fail screen
            timer.invalidate()
            circularTimer.angle = 0
            buttonGameOver.hidden = false
            button1.enabled = false
            button2.enabled = false
            button3.enabled = false
            button4.enabled = false
            var error:NSError?
            let failSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fail", ofType: "wav")!)
            //failPlayer = AVAudioPlayer(contentsOfURL: failSound, fileTypeHint: nil)
            failPlayer.prepareToPlay()
            failPlayer.play()
            
            // save highscore
            
            if (highScoreDefault.valueForKey("Highscore") != nil) && (highScoreDefault.valueForKey("Highscore") as! NSInteger > score) {
                
                highScorePrinted = highScoreDefault.valueForKey("Highscore") as! NSInteger!
                saveHighscore(score)
                
            } else {
                
                highScoreDefault.setValue(score, forKey: "Highscore")
                highScoreDefault.synchronize()
            }
        }
    }
    
    func timerSpeedUp() {
        if timerSpeed > 0.85 {
            timerSpeed = timerSpeed * 0.9
        }
        
    }
    
    func updateScore() {
        score++
        self.scoreLabel.text = "score: \(score)"
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @IBAction func button1Action(sender: AnyObject) {
        //checkCorrect(button1)
        if circle.backgroundColor == button1.backgroundColor {
            randomBasicColors()
            timerSpeedUp()
            resetTimer()
            updateScore()
        } else {
            gameOver()
        }
    }
    
    @IBAction func button2Action(sender: AnyObject) {
        //checkCorrect(button2)
        if circle.backgroundColor == button2.backgroundColor {
            randomBasicColors()
            timerSpeedUp()
            resetTimer()
            updateScore()
        } else {
            gameOver()
        }
    }
    
    @IBAction func button3Action(sender: AnyObject) {
        //checkCorrect(button3)
        if circle.backgroundColor == button3.backgroundColor {
            randomBasicColors()
            timerSpeedUp()
            resetTimer()
            updateScore()
        } else {
            gameOver()
        }
    }
    
    @IBAction func button4Action(sender: AnyObject) {
        //checkCorrect(button4)
        if circle.backgroundColor == button4.backgroundColor {
            randomBasicColors()
            timerSpeedUp()
            resetTimer()
            updateScore()
        } else {
            gameOver()
        }
    }
    
    @IBAction func buttonGameOverAction(sender: AnyObject) {
        //self.performSegueWithIdentifier("SendScore", sender: score)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let theDestination = (segue.destinationViewController as! SecondViewController)
        theDestination.scorePrinted = score
        theDestination.highScoreDefaultSync = highScoreDefault
        theDestination.highScorePrintedSync = highScorePrinted
    }
    
}





