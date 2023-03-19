//
//  SelectGenreViewController.swift
//  TOEICQuiz
//
//  Created by 佐藤響 on 2023/02/10.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class SelectGenreViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var verbButton: UIButton!
    @IBOutlet weak var nounButton: UIButton!
    @IBOutlet weak var adjectiveButton: UIButton!
    
    var selectGenre = 0
    var selectLev = 0
    
    var player: AVAudioPlayer?
    var playerButton:AVAudioPlayer?
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(headerView)

        if selectLev == 5 {
            labelName.text = "多義語"
            verbButton.isHidden = true
            nounButton.isHidden = true
            adjectiveButton.isHidden = true
        } else {
            labelName.text = "Level \(selectLev)"
        }
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2742119032760327/6772521787"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let numVC = segue.destination as! SelectNumViewController
        numVC.selectGenre = selectGenre
        numVC.selectLev = selectLev
        numVC.player = player
    }
    
    @IBAction func genreButtonActon(sender: UIButton) {
        selectGenre = sender.tag
        if let buttonURL = Bundle.main.url(forResource: "button", withExtension: "mp3") {
            do {
                playerButton = try AVAudioPlayer(contentsOf: buttonURL)
                playerButton?.play()
            } catch {
                print("error")
            }
        }
        performSegue(withIdentifier: "toNumberVC", sender: nil)
    }
    
    @IBAction func toSelectButtonAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
            NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0),])
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
