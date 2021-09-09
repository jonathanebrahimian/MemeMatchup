//
//  MemeCreationViewController.swift
//  MemeMatchup
//
//  Created by Jonathan Ebrahimian on 9/2/21.
//

import UIKit


class MemeCreationViewController: UIViewController, UITextFieldDelegate {

    lazy private var memeImage: UIImageView? = {
        return UIImageView.init(image: nil)
    }()
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeTextField: UITextField!
    
    @IBOutlet weak var memeScrollView: UIScrollView!
    @IBOutlet weak var colorPicker: UISegmentedControl!
    @IBOutlet weak var topBottomSwitch: UISwitch!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    //    var player_name:String = "";
    //    var numRounds = 1;
    //    var currRound = 1;
    
    //    var meme_url:String = "";
    
    //    var curr_player = 0;
    //    var num_players = 0;
    
    var colors = [UIColor.black, UIColor.red, UIColor.blue]
    var editing_bottom = true
    var timeLeft = 1000
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set image
        memeImage.image = MemeRoundsModel.shared.getImageFromName(name: MemeRoundsModel.shared.getCurrentMeme());
        
        // font size
        fontSizeSlider.value = 17;
        topBottomSwitch.isOn = editing_bottom;
        
        // colors
        topLabel.textColor = colors[0];
        bottomLabel.textColor = colors[0];
        
        // timer
        timeLeft = 1000;
        timerLabel.text = "\(timeLeft) seconds left";
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true);
        
        memeTextField.delegate = self;
        self.memeScrollView.addSubview(self.memeImage!)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        DispatchQueue.main.async{
            self.timerLabel.text = "\(self.timeLeft) seconds left"
        }
        

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            
            
            timeLeft = 3
            doneCreatingMeme((Any).self);
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        return true
    }
    

    @IBAction func memeTextChange(_ sender: Any) {
        let labelEditing = getCorrectLabel();
        DispatchQueue.main.async{
            labelEditing.text = self.memeTextField.text
        }
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
        if(MemeRoundsModel.shared.nextPlayer()) {
            print("Going to next player...")
            navigationController?.popViewController(animated: false)
        } else {
            print("Last player encountered, performing segue.")
            performSegue(withIdentifier: "GoToResults", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? RoundCollectionViewController{
            //            vc.numberOfPlayers = self.num_players;
            //            vc.numRounds = numRounds;
            //            vc.currRound = currRound;
            //            vc.round_count = round;
        }
    }
}


//extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//
//
//}
