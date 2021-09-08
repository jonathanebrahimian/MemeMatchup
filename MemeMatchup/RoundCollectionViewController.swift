//
//  RoundCollectionViewController.swift
//  MemeMatchup
//
//  Created by Zhengran Jiang on 9/6/21.
//question asked:

import UIKit

private let reuseIdentifier = "cellId"
//private var roundMeme = MemeRoundsModel.shared
private var testarr = ["test","test2","test3"];
private var ind = 0;
class RoundCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    @IBAction func winClick(_ sender: UIButton) {
        print("win selected");
        let cell = sender.nearestAncestor(ofType: UICollectionViewCell.self);
        
        let indexPath = self.collectionView?.indexPath(for: cell!);
        print(indexPath);
        if(currRound == numRounds){
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
                if let nav = navigationController{
                    nav.pushViewController(vc, animated: true)
                }
    //            self.present(vc, animated: true, completion: nil)
        
            }
            print("HERE")
        }
 
//        let result = ResultsViewController();
//        DispatchQueue.main.async {
//            self.navigationController?.pushViewController(result, animated: true)
//        }
       

    }
    
    var numberOfPlayers = 0;
    var currRound = 1;
    var numRounds = 1;
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
        return numberOfPlayers;
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, view.frame.height)
    }
    
    func CGSizeMake(_ width:CGFloat, _ height: CGFloat)->CGSize{
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath);
        
        if (ind < testarr.count){
//            var test = MemeRoundsModel.shared
//            var temp = test.getPlayers()
//            print(temp.count)
            var imageName = ""
            imageName = testarr[ind];
            ind = ind+1
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            cell.addSubview(imageView)
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
