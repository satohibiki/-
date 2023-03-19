//
//  ScoreViewController.swift
//  TOEICQuiz
//
//  Created by 佐藤響 on 2023/02/09.
//

import UIKit
import AVFoundation
import SwiftConfettiView
import GoogleMobileAds

class ScoreViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    var correct = 0
    var selectNum = 0
    
    var player: AVAudioPlayer?
    var playerEnd: AVAudioPlayer?
    var playerCheer: AVAudioPlayer?
    var bannerView: GADBannerView!
    
    var genreName = ""
    var levelName = ""
    var numberName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2742119032760327/6772521787"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        if let endingURL = Bundle.main.url(forResource: "end", withExtension: "mp3") {
            do {
                playerEnd = try AVAudioPlayer(contentsOf: endingURL)
                playerEnd?.numberOfLoops = -1
                playerEnd?.play()
            } catch {
                print("error")
            }
        }
        
        if selectNum == 100 {
            if correct == 30  {
                scoreLabel.text = "\(correct)問正解\n完璧！"
            } else if correct  >= 20 {
                scoreLabel.text = "\(correct)問正解\n素晴らしい！"
            } else if correct  >= 15 {
                scoreLabel.text = "\(correct)問正解\nよくできました！"
            } else if correct  >= 10 {
                scoreLabel.text = "\(correct)問正解\nもっと頑張りましょう！"
            } else {
                scoreLabel.text = "\(correct)問正解\n残念、もう少し頑張りましょう！"
            }
        } else {
            switch correct {
                case 10:
                    scoreLabel.text = "\(correct)問正解\n完璧！"
                case 9, 8:
                    scoreLabel.text = "\(correct)問正解\n素晴らしい！"
                case 7, 6:
                    scoreLabel.text = "\(correct)問正解\nよくできました！"
                case 5, 4, 3:
                    scoreLabel.text = "\(correct)問正解\nもっと頑張りましょう！"
                default:
                    scoreLabel.text = "\(correct)問正解\n残念、もう少し頑張りましょう！"
            }
        }
        
        if (selectNum == 100 && correct > 15) || (selectNum != 100 && correct > 5) {
            if let cheerURL = Bundle.main.url(forResource: "cheer", withExtension: "mp3") {
                do {
                    playerCheer = try AVAudioPlayer(contentsOf: cheerURL)
                    playerCheer?.play()
                } catch {
                    print("error")
                }
            }
            //紙吹雪
            let confettiView = SwiftConfettiView(frame: self.view.bounds)
            //Viewを追加
            self.view.addSubview(confettiView)
            //パーティクルの種類を設定
            confettiView.type = .confetti
            //パーティクルのカラーを設定
            confettiView.colors = [UIColor.purple, UIColor.systemPink, UIColor.blue, UIColor.green]
            //パーティクルの強度を設定
            confettiView.intensity = 1
            //紙吹雪をスタート
            confettiView.startConfetti()
            //3秒後に紙吹雪を停止する
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                confettiView.stopConfetti()
            }
            //6秒後にSubviewを削除する
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                confettiView.removeFromSuperview()
            }
        } else {
            if let cheerURL = Bundle.main.url(forResource: "cheer2", withExtension: "mp3") {
                do {
                    playerCheer = try AVAudioPlayer(contentsOf: cheerURL)
                    playerCheer?.play()
                } catch {
                    print("error")
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toTopButtonAction(_ sender: Any) {
        playerEnd?.stop()
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func toQuizButtonAction(_ sender: Any) {
        playerEnd?.stop()
        player?.play()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        
        let Date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        let activityItems = ["\(formatter.string(from: Date))\n\n\(levelName) \(genreName) \(numberName)\n\(correct)問正解しました!🎉\n\n#英単語マスター\n#英マス"]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true)
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
