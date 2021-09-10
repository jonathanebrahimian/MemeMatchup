//
//  MemeCreationViewController.swift
//  MemeMatchup
//
//  Created by Jonathan Ebrahimian on 9/2/21.
//

import UIKit


class MemeCreationViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    lazy private var memeImage: UIImageView? = {
        return UIImageView.init(image: MemeRoundsModel.shared.getImageFromURL(url_string: MemeRoundsModel.shared.getCurrentMemeURL()));
    }()
    
    
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
    
    lazy var colors = [UIColor.black, UIColor.red, UIColor.blue]
    lazy var editing_bottom = true
    lazy var timeLeft = 60
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true  ;
        // font size
        fontSizeSlider.value = 17;
        topBottomSwitch.isOn = editing_bottom;
        
        // colors
        topLabel.textColor = colors[0];
        bottomLabel.textColor = colors[0];
        
        // timer
        timeLeft = 60;
        timerLabel.text = "\(timeLeft)";
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true);
        
        memeTextField.delegate = self;
        if let size = self.memeImage?.image?.size{
            self.memeScrollView.addSubview(self.memeImage!);
            self.memeScrollView.contentSize = size;
            self.memeScrollView.minimumZoomScale = 0.1;
            
            self.memeScrollView.delegate = self;
            
            
            
        }

        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.memeImage;
    }
    
    @IBAction func tappedScreen(_ sender: Any) {
        self.memeTextField.resignFirstResponder();
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        DispatchQueue.main.async{
            self.timerLabel.text = "\(self.timeLeft)"
        }
        

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            
            timeLeft = 60
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
        MemeRoundsModel.shared.storeCaptions(forPlayer: MemeRoundsModel.shared.getCurrentPlayer(), topText: topLabel, bottomText: bottomLabel)
        
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
