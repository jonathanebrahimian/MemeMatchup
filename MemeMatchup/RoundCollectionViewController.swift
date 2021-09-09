//
//  RoundCollectionViewController.swift
//  MemeMatchup
//
//  Created by Zhengran Jiang on 9/6/21.
//question ask:

//current bugs:
//multiple rounds go out of bounds at ind
//declare winner abnormal

import UIKit

private let reuseIdentifier = "cellId"
private var ind = 0;
class RoundCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBAction func winClick(_ sender: UIButton) {
        print("win selected");
        let cell = sender.nearestAncestor(ofType: UICollectionViewCell.self);
        
        let indexPath = self.collectionView?.indexPath(for: cell!);
        print(indexPath);
        
        var playernames = MemeRoundsModel.shared.getPlayers()
        var player = playernames[indexPath!.row]
        MemeRoundsModel.shared.declareWinner(winner: player)
//        let name = MemeRoundsModel.shared.getCaptionedMemesForRound(round: currRound)[indexPath];
//        MemeRoundsModel.shared.declareWinner(winner: name)
        print("rounds")
        print(MemeRoundsModel.shared.currentRound)
        print(MemeRoundsModel.shared.numOfRounds)
        if(MemeRoundsModel.shared.currentRound > MemeRoundsModel.shared.numOfRounds){
            //if we go through all rounds
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultView") as? ResultsViewController
            {
                if let nav = navigationController{
                    nav.pushViewController(vc, animated: true)
                }
    //            self.present(vc, animated: true, completion: nil)
        
            }
            print("JERE")
        }
        else{
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoundStart") as? RoundStartViewController
            {
//                MemeRoundsModel.shared.incRound();
//                increase round by 1
//                vc.currRound = currRound + 1;
//                vc.round_count = numRounds;
//                vc.players = ["AAA","AAB"]
//                vc players = all player name in memes
//                we need to enter info again since its cleaned
                //round goes up
            
                if let nav = navigationController{
                    nav.pushViewController(vc, animated: true)
                }
    //            self.present(vc, animated: true, completion: nil)
        
            }
            print("HERE")
        }
    }
//    var scr = UIScrollView();
//    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.image
//    }

    let cellId = "cellId";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       
        
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
        
        if (ind < MemeRoundsModel.shared.getPlayers().count){

            print("sHARED")
//            print(MemeRoundsModel.shared.getPlayers())
//            var dict = MemeRoundsModel.shared.getCaptionedMemesForRound(round: MemeRoundsModel.shared.currentRound-1);
            var dict = MemeRoundsModel.shared.getCaptionedMemesForRound(round: ind);
//            current round start at 1 so -1
            var playernames = MemeRoundsModel.shared.getPlayers()
           
            var player = playernames[ind]
            print(dict[player]?.meme_url)
            
//            var img = arr[ind];
            print("Dict")
            print(dict)
            print("IND")
            print(ind)
            print("player")
            print(player)
            var imageName = ""
            imageName = dict[player]!.meme_url;
            print(imageName)
            ind = ind+1
            var url = URL(string: imageName)
            
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                var topLabel = UILabel(frame: CGRect(x:view.frame.width/2, y: view.frame.height/8, width: imageView.frame.size.width, height:20))
                topLabel = dict[player]!.topLabel
    //            topLabel.backgroundColor = UIColor.white
                imageView.addSubview(topLabel);
                
                var botLabel = UILabel(frame: CGRect(x:view.frame.width/2, y: view.frame.height*3/4, width: imageView.frame.size.width, height:20))
                botLabel = dict[player]!.bottomLabel
    //            topLabel.backgroundColor = UIColor.white
                imageView.addSubview(botLabel);
                cell.addSubview(imageView)
            }
            

//            imageView.translatesAutoresizingMaskIntoConstraints = false;
//            NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
//                NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
//                NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100).isActive = true
//                NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100).isActive = true
            
            
//            var scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
////            scroll.backgroundColor = .systemTeal
//            scroll.contentSize = CGSize(width: scroll.contentSize.width, height: scroll.contentSize.height)
//            scroll.minimumZoomScale = 0.1
//            scroll.maximumZoomScale = 4
////            scroll.delegate = self
//            scroll.addSubview(imageView)
////            cell.addSubview(imageView)
//            cell.addSubview(scroll)
        }
        
        
        
//        cell.backgroundColor = UIColor.red;
//        let roundLabel = UILabel(frame: CGRect(x:80,y:40,width: 40,height: 40))
//        roundLabel.text = "Round: " + String(currRound);
//        roundLabel.backgroundColor = UIColor.white;
//        roundLabel.frame = CGRect(x:80,y:40,width: roundLabel.intrinsicContentSize.width,height:roundLabel.intrinsicContentSize.height)
        
        let winBtn = UIButton(frame: CGRect(x:0,y:20,width: 70,height: 50));
        winBtn.backgroundColor = UIColor(red: 2/255, green: 117/255, blue: 216/255, alpha: 1)

        winBtn.layer.cornerRadius = 5;
        winBtn.layer.borderWidth = 1;
    
        winBtn.setTitle("win", for: .normal)
        winBtn.titleLabel?.textColor = UIColor.white;
        
        winBtn.addTarget(self, action: #selector(winClick(_:)), for: UIControl.Event.touchUpInside)
        
        cell.addSubview(winBtn);
        
//        cell.addSubview(roundLabel);
        return cell;
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


