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
        
        roundLabel.text = "Round: " + String(MemeRoundsModel.shared.currentRound);
        
        timerLabel.isHidden = true;
        timerLabel.text = "\(timeLeft)";
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playerNameLabel.text = MemeRoundsModel.shared.getCurrentPlayer();
    }
    
    @IBAction func readyClicked(_ sender: Any) {
        timerLabel.isHidden = false;
        readyButton.isHidden = true;
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        DispatchQueue.main.async {
            self.timerLabel.text = "\(self.timeLeft)"
        }

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            timerLabel.isHidden = true
            readyButton.isHidden = false
            performSegue(withIdentifier: "goToMemeCreation", sender: nil)
            timeLeft = 3
            timerLabel.text = "\(timeLeft)"
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let _ = segue.destination as? MemeCreationViewController{
//
//        }
//    }
}
