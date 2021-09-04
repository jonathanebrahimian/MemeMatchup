//
//  ViewController.swift
//  MemeMatchup
//
//  Created by Jonathan Ebrahimian on 9/2/21.
//

import UIKit

class HomeViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate,UITableViewDataSource {


    
    lazy var letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
    
    var players:[String] = [];
    
    @IBOutlet weak var addPlayerButton: UIButton!
    
    @IBOutlet weak var playerTable: UITableView!
    @IBOutlet weak var namePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        namePicker.isHidden = true
        namePicker.delegate = self;
        namePicker.dataSource = self;
        playerTable.delegate = self;
        playerTable.dataSource = self;
        // Do any additional setup after loading the view.
    }
    @IBAction func addPlayerClicked(_ sender: Any) {
        if namePicker.isHidden{
            self.players.append("AAA");
            DispatchQueue.main.async { [weak self] in
              //Reloading the tableview after ALL values appended.
              self?.playerTable.reloadData()
            }
            namePicker.isHidden = false
            namePicker.selectRow(0, inComponent: 0, animated: true);
            namePicker.selectRow(0, inComponent: 1, animated: true);
            namePicker.selectRow(0, inComponent: 2, animated: true);
            addPlayerButton.setTitle("Done", for: .normal);
        }else{
            namePicker.isHidden = true
            addPlayerButton.setTitle("Add Player", for: .normal);
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
        let currString = players[players.count-1];
        players[players.count-1] = String(currString.prefix(component) + letters[row] + currString.dropFirst(component+1));
        DispatchQueue.main.async { [weak self] in
          //Reloading the tableview after ALL values appended.
          self?.playerTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell",for: indexPath);
        
        cell.textLabel!.text = self.players[indexPath.row]
        
        return cell;
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RoundStartViewController{
            vc.players = self.players;
            vc.round_count = 0;
        }
    }


}

