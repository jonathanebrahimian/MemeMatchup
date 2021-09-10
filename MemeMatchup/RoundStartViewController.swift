//
//  RoundStartViewController.swift
//  MemeMatchup
//
//  Created by Jonathan Ebrahimian on 9/2/21.
//

import UIKit

class RoundStartViewController: UIViewController {
    
    var timer: Timer?
    lazy var timeLeft = 3
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var roundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.hidesBackButton = true ;
        DispatchQueue.main.async {
            self.roundLabel.text = "Round: " + String(MemeRoundsModel.shared.currentRound);
            self.timerLabel.isEnabled = true;
            self.timerLabel.text = "";
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.playerNameLabel.text = MemeRoundsModel.shared.getCurrentPlayer();
        }
    }
    
    @IBAction func readyClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.timerLabel.text = "\(self.timeLeft)";
        }
        readyButton.isEnabled = false;
        //https://learnappmaking.com/timer-swift-how-to/
        //learned how to create a timer form link above
        //call method (onTimerFires) every second
        // onTimerFires decrement var every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    //timer continuation from stack overflow linked above
    @objc func onTimerFires()
    {
        timeLeft -= 1
        DispatchQueue.main.async {
            self.timerLabel.text = "\(self.timeLeft)"
        }

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            timerLabel.text = ""
            readyButton.isEnabled = true
            performSegue(withIdentifier: "goToMemeCreation", sender: nil)
            timeLeft = 3
            DispatchQueue.main.async {
                self.timerLabel.text = ""
            }
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let _ = segue.destination as? MemeCreationViewController{
//
//        }
//    }
}
