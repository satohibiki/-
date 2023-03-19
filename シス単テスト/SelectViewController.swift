//
//  SelectViewController.swift
//  TOEICQuiz
//
//  Created by 佐藤響 on 2023/02/09.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class SelectViewController: UIViewController {
    
    var selectTag = 0
    var player: AVAudioPlayer?
    var playerButton:AVAudioPlayer?
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let soundURL = Bundle.main.url(forResource: "start", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.numberOfLoops = -1
                player?.play()
            } catch {
                print("error")
            }
        }
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2742119032760327/6772521787"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let genreVC = segue.destination as! SelectGenreViewController
        genreVC.selectLev = selectTag
        genreVC.player = player
    }
    
    @IBAction func levelButtonActon(sender: UIButton) {
        selectTag = sender.tag
        if let buttonURL = Bundle.main.url(forResource: "button", withExtension: "mp3") {
            do {
                playerButton = try AVAudioPlayer(contentsOf: buttonURL)
                playerButton?.play()
            } catch {
                print("error")
            }
        }
        performSegue(withIdentifier: "toSelectVC", sender: nil)
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
