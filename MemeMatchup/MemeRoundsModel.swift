//
//  MemeModel.swift
//  MemeMatchup
//
//  Created by Nathan Gage on 9/4/21.
//

import Foundation
import UIKit

struct CaptionedMeme {
    var meme_url: String
    var playerName: String
    var topLabel: UILabel
    var bottomLabel: UILabel
    var isWinner: Bool = false
}

class MemeRoundsModel: NSObject
{
    static let shared = MemeRoundsModel()
    
    private(set) var currentRound: Int = 1;
    public var numOfRounds: Int {
        get {
            return _numOfRounds
        }
        set {
            if newValue > numOfRounds
            {
                for _ in 1...(newValue-numOfRounds)
                {
                    currentMemes.append(getMemeWithoutReplacement())
                }
            }
            
            _numOfRounds = newValue
        }
    }
    
    lazy private var _numOfRounds: Int = 1
    lazy private var playerNames: [String] = []
    lazy private var rounds: [[String: CaptionedMeme]] = []
    lazy private var gameWins: [String: Int] = [:]
    lazy private var images: [String] = []
    lazy private var memeURLs: [String: String] = [:]
    lazy private var currentMemes: [String] = []
    lazy private var currentPlayerIndex: Int = 0
    
    private override init() {
        super.init()
        
        //https://stackoverflow.com/questions/24321165/make-rest-api-call-in-swift
        //learned syntax for making a rest API call from link above
        
        //configuring call
        var request = URLRequest(url: URL(string: "https://api.imgflip.com/get_memes")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        //api call and response capture
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                let data = json["data"] as! Dictionary<String, Array<Dictionary<String, AnyObject>>>
                
                let memes = data["memes"]!
                
                for meme in memes {
                    if meme["box_count"] as! Int == 2
                    {
                        self.memeURLs[meme["name"] as! String] = (meme["url"] as! String)
                    }
                }
                
                self.newGame()
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    func addPlayer(name: String)
    {
        playerNames.append(name)
    }
    
    func removePlayer(name: String)
    {
        playerNames.removeAll(where: {$0 == name})
    }
    
    func getPlayers() -> [String] {
        return playerNames;
    }
    
    func getCurrentPlayer() -> String {
        if playerNames.count != 0{
            return playerNames[currentPlayerIndex];
        }
        return "";
    }
    
    /// returns false if no more players to go next to
    func nextPlayer() -> Bool {
        currentPlayerIndex += 1
        
        if currentPlayerIndex >= playerNames.count
        {
            currentPlayerIndex = playerNames.count - 1
            return false
        } else {
            return true
        }
    }
    
    func getRoundWinsFor(player name: String) -> Int {
        var wins = 0
        
        for round in rounds
        {
            if ((round[name]!.isWinner))
            {
                wins += 1
            }
        }
        
        return wins
    }
    
    func getGameWinsFor(player name: String) -> Int {
        return gameWins[name, default: 0]
    }
    
    /// returns true when final round has been completed
    func declareWinner(winner name: String) -> Bool
    {
        currentPlayerIndex = 0
        
        rounds[currentRound - 1][name]?.isWinner = true
        currentRound += 1
        
        if currentRound > numOfRounds
        {
            endGame()
            return true
        }
        
        return false
    }
    
    func getCaptionedMemesForRound(round: Int) -> [String: CaptionedMeme]
    {
        return rounds[round - 1]
    }
    
    func getImageFromURL(url_string: String) -> UIImage {
        print("Attempting to download image \"\(url_string)\"...")
        
        let url = URL(string: url_string)
        let data = try? Data(contentsOf: url!)
        return UIImage(data: data!)!
    }
    
    func getCurrentMemeURL() -> String {
        return currentMemes[currentRound - 1]
    }
    
    func getMemeWithoutReplacement() -> String
    {
        // could error if we use up all the memes
        let randomIndex = Int.random(in: 1...(memeURLs.count - 1))
        memeURLs.removeValue(forKey: Array(memeURLs.keys)[randomIndex])
        return Array(memeURLs.values)[randomIndex]
    }
    
    func storeCaptions(forPlayer: String, topText: UILabel, bottomText: UILabel)
    {
        print("Storing meme for player \"\(forPlayer)\" with captions: \n\t\(String( topText.text!)) \n\t\(String(bottomText.text!))")
        
        // prepopulate rounds
        while rounds.count < numOfRounds
        {
            rounds.append([:])
        }
        
        // add meme for player
        rounds[currentRound - 1][forPlayer] = CaptionedMeme(meme_url: getCurrentMemeURL(), playerName: forPlayer, topLabel: topText, bottomLabel: bottomText)
    }
    
    func newGame() {
        currentPlayerIndex = 0
        currentMemes.removeAll()
        playerNames.removeAll()
        
        for _ in 1...numOfRounds
        {
            currentMemes.append(getMemeWithoutReplacement())
        }
        
        rounds.removeAll()
        currentRound = 1
    }
    
    func endGame() {
        var wins: [String: Int] = [:]
        
        for round in rounds {
            for meme in round
            {
                if meme.value.isWinner
                {
                    wins[meme.key, default: 0] += 1
                }
            }
        }
        
        var winner = ""
        for win in wins {
            if win.value > wins[winner, default: 0]
            {
                winner = win.key
            }
        }
        
        gameWins[winner, default: 0] += 1
        
//        newGame()
    }
}
