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
    
    @IBOutlet weak var memeLabel: UILabel!
    var player_name:String = "";
    var meme_url:String = "";
    var curr_player = 0;
    var num_players = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.downloaded(from:meme_url);

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func memeTextChange(_ sender: Any) {
        memeLabel.text = memeTextField.text
    }
    

    @IBAction func doneCreatingMeme(_ sender: Any) {
        if self.curr_player <   self.num_players-1 {
            navigationController?.popViewController(animated: false)
        }else{
            performSegue(withIdentifier: "goToResults", sender: nil)
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
