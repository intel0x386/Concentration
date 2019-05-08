//
//  HowToViewController.swift
//  Concentration
//
//  Created by ankit on 02/05/19.
//  Copyright © 2019 ankit. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController {

    
    @IBOutlet weak var howToTextView: UITextView!
    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        print("DIsmiss pressed")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        howToTextView.text = "Tap on a Card to open it. Then tap on another card that you remember has the same emoji. Initially you will open the cards at random because you won't know which card has what emoji. Later when you do not remember the correct emoji-card for the opened card, you will have a miss and the number of misses will be displayed on the top."
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
