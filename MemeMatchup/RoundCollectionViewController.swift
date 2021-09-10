//
//  RoundCollectionViewController.swift
//  MemeMatchup
//
//  Created by Zhengran Jiang on 9/6/21.

import UIKit

class RoundCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBAction func winClick(_ sender: UIButton) {
        
        let cell = sender.nearestAncestor(ofType: UICollectionViewCell.self);
        let indexPath = self.collectionView?.indexPath(for: cell!);
        var playernames = MemeRoundsModel.shared.getPlayers()
        var player = playernames[indexPath!.row]
        MemeRoundsModel.shared.declareWinner(winner: player)
        print("Winner: ")
        print(indexPath)
//        print(MemeRoundsModel.shared.currentRound)
//        print(MemeRoundsModel.shared.numOfRounds)
        if(MemeRoundsModel.shared.currentRound > MemeRoundsModel.shared.numOfRounds){
            //if we go through all rounds
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultView") as? ResultsViewController
            {
                if let nav = navigationController{
                    nav.pushViewController(vc, animated: true)
                }
        
            }
            
        }
        else{
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoundStart") as? RoundStartViewController
            {
            
                if let nav = navigationController{
                    nav.pushViewController(vc, animated: true)
                }
    //            self.present(vc, animated: true, completion: nil)
        
            }
            
        }
    }

    let cellId = "cellId";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        navigationItem.hidesBackButton = true  ;
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0);
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0);
        
        collectionView?.register(UICollectionViewCell.self,
                                      forCellWithReuseIdentifier: cellId)
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return MemeRoundsModel.shared.getPlayers().count;
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, view.frame.height)
    }
    
    func CGSizeMake(_ width:CGFloat, _ height: CGFloat)->CGSize{
        return CGSize(width: width, height: height)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath);
        
        // get memes with captions
        let roundMemes = MemeRoundsModel.shared.getCaptionedMemesForRound(round: MemeRoundsModel.shared.currentRound)
        
        // Set the imageview
        let imageView: UIImageView = UIImageView()
        imageView.image = MemeRoundsModel.shared.getImageFromURL(url_string: MemeRoundsModel.shared.getCurrentMemeURL())
        
        print("ROUND MEMES:")
        print(roundMemes)
        
        // Set the toptext
        //https://stackoverflow.com/questions/31503580/programmatically-set-position-of-swift-element
        //Learned about translates auto resizing mask into constraints from the stack overflow above ^ (allows movement of labels programatically)
        let topLabel: UILabel = roundMemes[MemeRoundsModel.shared.getPlayers()[indexPath.row]]!.topLabel
        topLabel.translatesAutoresizingMaskIntoConstraints = true
        topLabel.numberOfLines = 2
                
        // Set the bottomtext
        let bottomLabel: UILabel = roundMemes[MemeRoundsModel.shared.getPlayers()[indexPath.row]]!.bottomLabel
        bottomLabel.translatesAutoresizingMaskIntoConstraints = true
        bottomLabel.numberOfLines = 2
        
        
        // Create the button
        let winBtn = UIButton(frame: CGRect(x:0,y:20,width: 70,height: 50));
        winBtn.backgroundColor = UIColor(red: 2/255, green: 117/255, blue: 216/255, alpha: 1)

        winBtn.layer.cornerRadius = 5;
        winBtn.layer.borderWidth = 1;
    
        winBtn.setTitle("win", for: .normal)
        winBtn.titleLabel?.textColor = UIColor.white;
        
        winBtn.addTarget(self, action: #selector(winClick(_:)), for: UIControl.Event.touchUpInside)
        
        // Set positions
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        topLabel.frame = CGRect(x: (view.frame.width/2), y: (view.frame.height/8), width: imageView.frame.size.width, height:80)
        topLabel.center.x = view.center.x
        topLabel.center.y = view.center.y/4
        
        bottomLabel.frame = CGRect(x: (view.frame.width/2), y: (view.frame.height*3/4), width: imageView.frame.size.width, height:80)
        bottomLabel.center.x = view.center.x
        bottomLabel.center.y = view.center.y * 1.5
        
        // Add everything to cell
        imageView.addSubview(topLabel)
        imageView.addSubview(bottomLabel)
        
        cell.addSubview(imageView)
        cell.addSubview(winBtn);
        
        return cell
        
    }

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//
//        // Configure the cell
//
//        return cell
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension UIView {
    func nearestAncestor<T>(ofType type: T.Type) -> T? {
        if let me = self as? T { return me }
        return superview?.nearestAncestor(ofType: type)
    }
}


