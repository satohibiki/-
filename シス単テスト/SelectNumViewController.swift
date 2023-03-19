//
//  SelectNumViewController.swift
//  シス単テスト
//
//  Created by 佐藤響 on 2023/03/04.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class SelectNumViewController: UIViewController {
    
    @IBOutlet weak var genreName: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button12: UIButton!
    @IBOutlet weak var button13: UIButton!
    @IBOutlet weak var button14: UIButton!
    @IBOutlet weak var button15: UIButton!
    @IBOutlet weak var button16: UIButton!
    @IBOutlet weak var button17: UIButton!
    @IBOutlet weak var button18: UIButton!
    @IBOutlet weak var button19: UIButton!
    @IBOutlet weak var button20: UIButton!
    @IBOutlet weak var button21: UIButton!
    
    @IBOutlet weak var scrollView: UIView!
    
    
    
    var selectGenre = 0
    var selectLev = 0
    var selectNum = 0
    
    var player: AVAudioPlayer?
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2742119032760327/6772521787"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        button21.isHidden = true
        
        switch selectGenre {
        case 1:
            genreName.text = "動詞"
        case 2:
            genreName.text = "名詞"
        case 3:
            genreName.text = "形容詞・副詞"
        default:
            genreName.text = "総合"
            if selectLev != 5 {
                button1.isHidden = true
                button2.isHidden = true
                button3.isHidden = true
                button4.isHidden = true
                button5.isHidden = true
                button6.isHidden = true
                button7.isHidden = true
                button8.isHidden = true
                button9.isHidden = true
                button10.isHidden = true
            }
            button11.isHidden = true
            button12.isHidden = true
            button13.isHidden = true
            button14.isHidden = true
            button15.isHidden = true
            button16.isHidden = true
            button17.isHidden = true
            button18.isHidden = true
            button19.isHidden = true
            button20.isHidden = true
        }
        
        switch selectLev {
        case 1:
            switch selectGenre{
            case 3:
                button16.isHidden = true
                button17.isHidden = true
                button18.isHidden = true
                button19.isHidden = true
                button20.isHidden = true
            default:
                break
            }
        case 2:
            switch selectGenre{
            case 3:
                button16.isHidden = true
                button17.isHidden = true
                button18.isHidden = true
                button19.isHidden = true
                button20.isHidden = true
            default:
                break
            }
        case 3:
            switch selectGenre{
            case 1:
                button20.isHidden = true
            case 2:
                button21.isHidden = false
            case 3:
                button10.isHidden = true
                button11.isHidden = true
                button12.isHidden = true
                button13.isHidden = true
                button14.isHidden = true
                button15.isHidden = true
                button16.isHidden = true
                button17.isHidden = true
                button18.isHidden = true
                button19.isHidden = true
                button20.isHidden = true
            default:
                break
            }
        case 4:
            switch selectGenre{
            case 1:
                button10.isHidden = true
                button11.isHidden = true
                button12.isHidden = true
                button13.isHidden = true
                button14.isHidden = true
                button15.isHidden = true
                button16.isHidden = true
                button17.isHidden = true
                button18.isHidden = true
                button19.isHidden = true
                button20.isHidden = true
            case 3:
                button9.isHidden = true
                button10.isHidden = true
                button11.isHidden = true
                button12.isHidden = true
                button13.isHidden = true
                button14.isHidden = true
                button15.isHidden = true
                button16.isHidden = true
                button17.isHidden = true
                button18.isHidden = true
                button19.isHidden = true
                button20.isHidden = true
            default:
                break
            }
        default:
            break
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let quizVC = segue.destination as! QuizViewController
        quizVC.selectGenre = selectGenre
        quizVC.selectLevel = selectLev
        quizVC.selectNum = selectNum
        quizVC.player = player
    }
    
    @IBAction func numberButtonAction(sender: UIButton) {
        selectNum = sender.tag
        player?.stop()
        performSegue(withIdentifier: "toQuizVC", sender: nil)
    }
    
    @IBAction func toGenreButtonAction(_ sender: Any) {
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
