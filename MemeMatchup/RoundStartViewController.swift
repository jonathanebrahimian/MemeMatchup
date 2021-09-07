//
//  RoundStartViewController.swift
//  MemeMatchup
//
//  Created by Jonathan Ebrahimian on 9/2/21.
//

import UIKit

class RoundStartViewController: UIViewController {
    
    var player_name:String = "Jonathan Ebrahimian";
    @IBOutlet weak var playerNameLabel: UILabel!
    var players:[String] = [];
    var round_count = 0;
    var currRound = 1;
    var curr_player = 0;
    var url = "";
    var timer:Timer?
    var timeLeft = 3
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var readyButton: UIButton!
    
    @IBOutlet weak var roundLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundLabel.text = "Round: " + String(currRound);
        timerLabel.isHidden = true;
        timerLabel.text = "\(timeLeft) seconds left";
        playerNameLabel.text = players[curr_player];
        
        var request = URLRequest(url: URL(string: "https://api.imgflip.com/get_memes")!)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                let data = json["data"]!;
                let memes = data["memes"] as? [Any];
                let meme = memes![Int.random(in:0...memes!.count)] as! Dictionary<String, Any>
                self.url = meme["url"] as! String;
                
            } catch {
                print("error")
            }
        })

        task.resume();
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readyClicked(_ sender: Any) {
        timerLabel.isHidden = false;
        readyButton.isHidden = true;
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timerLabel.text = "\(timeLeft) seconds left"

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            timerLabel.isHidden = true
            readyButton.isHidden = false
            performSegue(withIdentifier: "goToMemeCreation", sender: nil)
            timeLeft = 3
            timerLabel.text = "\(timeLeft) seconds left"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MemeCreationViewController{
            self.curr_player += 1;
            vc.player_name = self.player_name;
            vc.meme_url = self.url;
            vc.curr_player = self.curr_player;
            vc.num_players = self.players.count;
            vc.numRounds = round_count;
            vc.currRounds = currRound;
        }
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
