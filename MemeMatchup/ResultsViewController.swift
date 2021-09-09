//
//  ResultsViewController.swift
//  MemeMatchup
//
//  Created by Jonathan Ebrahimian on 9/2/21.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var firstPlaceLabel: UILabel!
    
    @IBOutlet weak var secondPlaceLabel: UILabel!
    
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let players = MemeRoundsModel.shared.getPlayers()
        var playerScores: Dictionary<String, Int> = [:]
        
        for player in players
        {
            playerScores[player, default: 0] = MemeRoundsModel.shared.getRoundWinsFor(player: player)
        }
        
        let sortedScores = playerScores.sorted { (first, second) -> Bool in
            return first.value > second.value
        }
        
        print("Displaying final scores: \(sortedScores)")
        
        if let first = sortedScores[safe: 0]
        {
            if first.value > 1
            {
                firstPlaceLabel.text = "👑 \(first.key) - \(first.value) Votes"
            }
            else {
                firstPlaceLabel.text = "👑 \(first.key) - \(first.value) Vote"
            }
        }
        else {
            firstPlaceLabel.text = ""
        }
        
        if let second = sortedScores[safe: 1]
        {
            if second.value != 1
            {
                secondPlaceLabel.text = "🎉 \(second.key) - \(second.value) Votes"
            }
            else {
                secondPlaceLabel.text = "🎉 \(second.key) - \(second.value) Vote"
            }
        }
        else {
            secondPlaceLabel.text = ""
        }
        
        if let third = sortedScores[safe: 2]
        {
            if third.value != 1
            {
                thirdPlaceLabel.text = "💩 \(third.key) - \(third.value) Votes"
            }
            else {
                thirdPlaceLabel.text = "💩 \(third.key) - \(third.value) Vote"
            }
        }
        else {
            thirdPlaceLabel.text = ""
        }
    }
    
    
    @IBAction func onBackToHome(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//        self.present(nextViewController, animated:true, completion:nil)
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? HomeViewController
        {
            MemeRoundsModel.shared.newGame()
        
            if let nav = navigationController{
                nav.pushViewController(vc, animated: true)
            }
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

// https://stackoverflow.com/a/30593673/13009703
extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
