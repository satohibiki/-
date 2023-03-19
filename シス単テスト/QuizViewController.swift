//
//  QuizViewController.swift
//  TOEICQuiz
//
//  Created by 佐藤響 on 2023/02/09.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class QuizViewController: UIViewController {
    @IBOutlet weak var quizNumberView: UILabel!
    @IBOutlet weak var quizTextView: UITextView!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var judgeImageView: UIImageView!
    @IBOutlet weak var answerText: UITextField!
    @IBOutlet weak var correctAnswer: UILabel!
    @IBOutlet weak var levelLavel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    
    var bannerView: GADBannerView!
    var csvArray: [String] = []
    var quizArray: [String] = []
    var quizCount = 0
    var quizNum = 10
    var correctCount = 0
    var selectLevel = 0
    var selectGenre = 0
    var selectNum = 0
    
    var answerData = ""
    var genreName = ""
    var levelName = ""
    var numberName = ""
    
    var player: AVAudioPlayer?
    var playerQuiz: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(headerView)
        nextButton.layer.cornerRadius = 30;
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2742119032760327/6772521787"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        answerText.placeholder = "回答を入力"
        
        if selectNum == 100{
            csvArray = loadCSV(fileName: "quiz\(selectLevel)\(selectGenre)")
            quizNum = 30
            numberName = "ランダム30問"
            
            // リストの空文字列削除
            for i in (0..<csvArray.count).reversed() {
                if csvArray[i] == "" {
                    csvArray.remove(at: i)  // 空文字列の要素を削除する
                }
            }
        } else {
            csvArray = loadCSV(fileName: "quiz\(selectLevel)\(selectGenre)\(selectNum)")
            numberName = "No. \(selectNum)"
            
            // リストの空文字列削除
            for i in (0..<csvArray.count).reversed() {
                if csvArray[i] == "" {
                    csvArray.remove(at: i)
                }
            }
        }
        
        numberLabel.text = numberName
        csvArray.shuffle()
        
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        
        quizNumberView.text = "第\(quizCount + 1)問"
        quizTextView.text = "\(quizArray[2])\n" + "(\(String(quizArray[1]).count)文字)"
        correctAnswer.text = ""
        
        if let upURL = Bundle.main.url(forResource: "up", withExtension: "mp3") {
            do {
                playerQuiz = try AVAudioPlayer(contentsOf: upURL)
                playerQuiz?.play()
            } catch {
                print("error")
            }
        }
        
        switch selectGenre {
        case 1:
            genreName = "動詞"
        case 2:
            genreName = "名詞"
        case 3:
            genreName = "形容詞・副詞"
        default:
            genreName = "総合"
        }
        
        if selectLevel == 5 {
            levelName = "多義語編"
        } else {
            levelName = "Level \(selectLevel)"
        }
        
        levelLavel.text = levelName + " " + genreName

        nextButton.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correct = correctCount
        scoreVC.selectNum = selectNum
        scoreVC.genreName = genreName
        scoreVC.levelName = levelName
        scoreVC.numberName = numberName
        scoreVC.player = player
    }
    
    @IBAction func btnAction(sender: UIButton) {
        dismissKeyboard()
        answerData = answerText.text!
        if answerData == quizArray[1] {
            correctAnswer.text = "正解!"
            print("正解")
            correctCount += 1
            judgeImageView.image = UIImage(named: "correct")
            if let soundURL = Bundle.main.url(forResource: "correct", withExtension: "mp3") {
                do {
                    playerQuiz = try AVAudioPlayer(contentsOf: soundURL)
                    playerQuiz?.play()
                } catch {
                    print("error")
                }
            }
        } else {
            correctAnswer.text = "正解: " + quizArray[1]
            print("不正解")
            judgeImageView.image = UIImage(named: "incorrect")
            if let soundURL = Bundle.main.url(forResource: "incorrect", withExtension: "mp3") {
                do {
                    playerQuiz = try AVAudioPlayer(contentsOf: soundURL)
                    playerQuiz?.play()
                } catch {
                    print("error")
                }
            }
        }
        answerText.text = ""
        nextButton.isHidden = false
        correctAnswer.isHidden = false
        judgeImageView.isHidden = false
        answerButton.isEnabled = false
        answerText.isEnabled = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
           
        guard let keyboardMinY = keyboardFrame?.minY else{ return }
        let buttonMaxY = quizTextView.frame.maxY
        let distance = buttonMaxY - keyboardMinY + 250
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: []
                        , animations: {
                        self.answerText.transform = transform})
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: []
                        , animations: {
                        self.answerButton.transform = transform})
    }

    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: []
                        , animations: {
                        self.answerText.transform = .identity})
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: []
                        , animations: {
                        self.answerButton.transform = .identity})
    }
    
    @IBAction func nextButtonAction(_ sender: Any){
        self.nextButton.isHidden = true
        self.judgeImageView.isHidden = true
        self.correctAnswer.isHidden = true
        self.answerButton.isEnabled = true
        answerText.isEnabled = true
        self.nextQuiz()
    }
    
    @IBAction func toTopButtonAction(_ sender: Any) {
        player?.play()
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func nextQuiz() {
        quizCount += 1
        if quizCount < quizNum {
            quizArray = csvArray[quizCount].components(separatedBy: ",")
            
            quizNumberView.text = "第\(quizCount + 1)問"
            quizTextView.text = "\(quizArray[2])\n" + "(\(String(quizArray[1]).count)文字)"
            if let soundURL = Bundle.main.url(forResource: "up", withExtension: "mp3") {
                do {
                    playerQuiz = try AVAudioPlayer(contentsOf: soundURL)
                    playerQuiz?.play()
                } catch {
                    print("error")
                }
            }
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
        
    }
    
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do{
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("エラー")
        }
        return csvArray
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
