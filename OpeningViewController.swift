//
//  OpeningViewController.swift
//  The Big Mysterious App
//
//  Created by Joanna Chen on 2015-08-28.
//  Copyright (c) 2015 Jocular Cows Inc. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {

    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var gameName: UILabel!
    
    var blue = UIColor(red: 0x66/255, green: 0x99/255, blue: 0xff/255, alpha: 1.0)
    var orange = UIColor(red: 0xff/255, green: 0xcc/255, blue: 0x66/255, alpha: 1.0)
    var pink = UIColor(red: 0xff/255, green: 0x99/255, blue: 0x99/255, alpha: 1.0)
    var green = UIColor(red: 0x75/255, green: 0xff/255, blue: 0xa3/255, alpha: 1.0)
    
    func shuffleArray<T>(var array: [T]) -> [T] {
        for index in Array(0..<array.count) {
            let randomIndex = Int(arc4random_uniform(UInt32(index)))
            (array[index], array[randomIndex]) = (array[randomIndex], array[index])
        }
        return array
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var basicColors = [blue, orange, pink, green]
        var randomNumber = [-1, 0, 1, 2, 3]
        randomNumber = shuffleArray(randomNumber)
        gameName.textColor = basicColors[randomNumber[0]] as UIColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonStartAction(sender: AnyObject) {
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
