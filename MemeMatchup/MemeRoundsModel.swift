//
//  MemeModel.swift
//  MemeMatchup
//
//  Created by Nathan Gage on 9/4/21.
//

import Foundation
import UIKit

struct CaptionedMeme {
    var meme: String
    var topLabel: UILabel
    var bottomLabel: UILabel
    var isWinner: Bool = false
}

class MemeRoundsModel
{
    static let shared = MemeRoundsModel()
    
    public var numOfRounds: Int {
        get {
            return _numOfRounds
        }
        set {
            if newValue > numOfRounds
            {
                // download more memes
            }
            
            _numOfRounds = newValue
        }
    }
    
    private var _numOfRounds: Int = 3
    private var playerNames: [String] = []
    private var currentRound: Int = 1;
    private var rounds: [[String: CaptionedMeme]] = []
    private var gameWins: [String: Int] = [:]
    private var images: [String] = []
    private var url: String = ""
    
    private init() {
        // download images for numOfRounds
    }
    
    func storeMeme(meme: String, topText: UILabel, bottomText: UILabel, user: String, round: Int)
    {
        rounds[round - 1][user] = CaptionedMeme(meme: meme, topLabel: topText, bottomLabel: bottomText)
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
    
    func getRoundWinsFor(player name: String) -> Int {
        var wins = 0
        
        for round in rounds
        {
            if ((round[name]?.isWinner) != nil)
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
        return rounds[round]
    }
    
    // func getImageFromName(name: String) -> UIImage {}
    
    func newGame() {
        // download new memes
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
        
        newGame()
    }
}
