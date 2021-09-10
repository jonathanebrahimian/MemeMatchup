//
//  ViewController.swift
//  MemeMatchup
//
//  Created by Jonathan Ebrahimian on 9/2/21.
//

import UIKit

class HomeViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate,UITableViewDataSource {

    lazy var letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    
//    var players:[String] = [];
//    var round:Int = MemeRoundsModel.shared.numOfRounds;
    
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var playerTable: UITableView!
    @IBOutlet weak var namePicker: UIPickerView!
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        valueLabel.text = Int(sender.value).description;
        MemeRoundsModel.shared.numOfRounds = Int(Int(sender.value).description) ?? 1;
        print(MemeRoundsModel.shared.numOfRounds)
        //        here we store the round number
        //        if it is nil or invalid, use 1 as default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namePicker.isHidden = true
        namePicker.delegate = self;
        namePicker.dataSource = self;
        playerTable.delegate = self;
        playerTable.dataSource = self;
        stepper.autorepeat = true;
        navigationItem.hidesBackButton = true  ;
        // Do any additional setup after loading the view.
        
//        MemeRoundsModel.shared.getPlayers()
        DispatchQueue.main.async { [weak self] in
            //Reloading the tableview after ALL values appended.
            self?.playerTable.reloadData()
        }
    }
    
    
    
    
    @IBAction func addPlayerClicked(_ sender: Any) {
        if namePicker.isHidden{
            namePicker.isHidden = false
            
            namePicker.selectRow(0, inComponent: 0, animated: true);
            namePicker.selectRow(0, inComponent: 1, animated: true);
            namePicker.selectRow(0, inComponent: 2, animated: true);
            
            addPlayerButton.setTitle("Done", for: .normal);
        }else{
            DispatchQueue.main.async { [weak self] in
                //Reloading the tableview after ALL values appended.
                self?.playerTable.reloadData()
            }
            
            let newPlayer: String = letters[namePicker.selectedRow(inComponent: 0)] + letters[namePicker.selectedRow(inComponent: 1)] + letters[namePicker.selectedRow(inComponent: 2)]
            
            if !MemeRoundsModel.shared.getPlayers().contains(newPlayer)
            {
                print("Adding player \(newPlayer)")
                MemeRoundsModel.shared.addPlayer(name: newPlayer)
                
                namePicker.isHidden = true
                addPlayerButton.setTitle("Add Player", for: .normal);
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return letters.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return letters[row] as String;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let currString = players[players.count-1];
//        players[players.count-1] = String(currString.prefix(component) + letters[row] + currString.dropFirst(component+1));
        DispatchQueue.main.async { [weak self] in
            //Reloading the tableview after ALL values appended.
            self?.playerTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeRoundsModel.shared.getPlayers().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell",for: indexPath);
        
        cell.textLabel!.text = MemeRoundsModel.shared.getPlayers()[indexPath.row]
        
        return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? RoundStartViewController{
            
//            vc.players = MemeRoundsModel.shared.getPlayers();
//            vc.round_count = MemeRoundsModel.shared.numOfRounds;
        }
    }
}

