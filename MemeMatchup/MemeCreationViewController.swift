//
//  MemeCreationViewController.swift
//  MemeMatchup
//
//  Created by Jonathan Ebrahimian on 9/2/21.
//

import UIKit


class MemeCreationViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeTextField: UITextField!
    
    @IBOutlet weak var colorPicker: UISegmentedControl!
    @IBOutlet weak var topBottomSwitch: UISwitch!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var bottomLabel: UILabel!
    var player_name:String = "";
    
    var meme_url:String = "";
    
    var colors = [UIColor.black,UIColor.red,UIColor.blue];
    
    @IBOutlet weak var topLabel: UILabel!
    var curr_player = 0;
    var num_players = 0;
    var editing_bottom = true;
    @IBOutlet weak var timerLabel: UILabel!
    var timeLeft = 1000;
    var timer:Timer?;
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.downloaded(from:meme_url);
        fontSizeSlider.value = 17;
        topBottomSwitch.isOn = editing_bottom;
        topLabel.textColor = colors[0];
        bottomLabel.textColor = colors[0];
        timeLeft = 1000;
        timerLabel.text = "\(timeLeft) seconds left";
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true);
        
        // Do any additional setup after loading the view.
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timerLabel.text = "\(timeLeft) seconds left"

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            
            
            timeLeft = 3
            doneCreatingMeme((Any).self);
        }
    }
    
    

    @IBAction func memeTextChange(_ sender: Any) {
        let labelEditing = getCorrectLabel();
        labelEditing.text = memeTextField.text
    }
    
    func getCorrectLabel() -> UILabel{
        let labelEditing:UILabel;
        if editing_bottom {
            labelEditing = bottomLabel;
        }else{
            labelEditing = topLabel;
        }
        return labelEditing;
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        let labelEditing = getCorrectLabel();
        labelEditing.font = labelEditing.font.withSize(CGFloat(fontSizeSlider.value));
    }
    
    @IBAction func borderChange(_ sender: Any) {
        let labelEditing = getCorrectLabel();
        labelEditing.textColor = colors[colorPicker.selectedSegmentIndex];
    }
    
    @IBAction func topBottomToggle(_ sender: Any) {
        if self.editing_bottom {
            self.editing_bottom = false;
            self.memeTextField.text = topLabel.text;
            self.fontSizeSlider.value = Float(topLabel.font.pointSize);
            self.colorPicker.selectedSegmentIndex = colors.firstIndex(of: topLabel.textColor)!;
        }else{
            self.editing_bottom = true;
            self.memeTextField.text = bottomLabel.text;
            self.fontSizeSlider.value = Float(bottomLabel.font.pointSize);
            self.colorPicker.selectedSegmentIndex = colors.firstIndex(of: bottomLabel.textColor)!;
        }
    }
    
    @IBAction func doneCreatingMeme(_ sender: Any) {
        if self.curr_player <   self.num_players-1 {
            navigationController?.popViewController(animated: false)
        }else{
            print("CLICKED")
            print(curr_player)
            print(num_players)
//            performSegue(withIdentifier: "RoundResult", sender: nil)


        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RoundCollectionViewController{
            vc.numberOfPlayers = self.num_players;
            vc.numRounds = numRounds;
            vc.currRound = currRounds;
//            vc.round_count = round;
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


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    

}
