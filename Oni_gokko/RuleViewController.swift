//
//  RuleViewController.swift
//  Oni_gokko
//
//  Created by 若林俊輔 on 2015/10/02.
//  Copyright (c) 2015年 p6iwi6q. All rights reserved.
//


import UIKit

class RuleViewController: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!
    @IBAction func back(sender: AnyObject) {
    }
    @IBOutlet weak var backToTop: UIButton!

    let w = UIScreen.mainScreen().bounds.size.width
    let h = UIScreen.mainScreen().bounds.size.height
    let nw = UIScreen.mainScreen().nativeBounds.size.width
    let nh = UIScreen.mainScreen().nativeBounds.size.height
    let aw = UIScreen.mainScreen().applicationFrame.size.width
    let ah = UIScreen.mainScreen().applicationFrame.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景を灰色に設定する.
        self.view.backgroundColor = UIColor(red: 31/255, green: 36/255, blue: 38/255, alpha: 1.0)
        
        // TextView生成する.
        let myTextView: UITextView = UITextView(frame: CGRectMake(10, 55, self.view.frame.width - 20, 3/4 * h ))
        
        // TextViewの背景を黃色に設定する.
        myTextView.backgroundColor = UIColor(red: 31/255, green: 36/255, blue: 38/255, alpha: 1.0)
        
        // 表示させるテキストを設定する.
        myTextView.text = "Introduce the App\n\n\n Kingdomは新感覚のおにごっこアプリ!\n\n 三国志がモデルになっており、このゲームではプレイヤーは魏、呉、蜀の３チームに別れていち早く敵対するチームのKINGを捕まえることができるかで競い合う。\n\n相手プレイヤーに一定距離近づくことによって相手を捕まえることができる。\n特殊な無線やGPS、ゲーム内アイテムをおにごっこに組み込むことによって従来のおにごっことは違った楽しみ方が可能に！！\n\n\n\nRule\nゲームの流れ\n１、全員が”play”ボタンをタップする。\n\n２、自動で選出されたプレイヤーが、画面に表示されている参加者人数と実際に参加している人数が同じであることを確認して、”この人数ではじめる”をタップする。\n\n３、３分間のカウントダウンが始まる。その３分間がそれぞれのプレイヤーに逃走する時間ある。\n\n４、その後、ゲーム開始直後、自分の在籍するチームと役職が発表される。相手チームは追う側と追われる側の２タイプのチームが存在する。（例：魏チームは呉チームを倒せるが、蜀チームに倒されてしまう。じゃんけんの相関図と同一である。プレイヤーは自分のチームとコミュニケーションをとりながら、自チームのKINGが捕まる前に相手チームのKINGを捕まえることでゲームに勝利する。\n\n\n\n役職\n・王：捕まったら自チームは敗北してしまう。\n・軍師：全プレイヤーの位置情報が分かる。チームのサポート役。\n・武人：相手を捕まえる範囲が２倍。最も攻撃力が高い。"
        
        // 角に丸みをつける.
        myTextView.layer.masksToBounds = true
        
        // 丸みのサイズを設定する.
        myTextView.layer.cornerRadius = 25.0
        
        // 枠線の太さを設定する.
        //myTextView.layer.borderWidth = 1
        
        // 枠線の色を黒に設定する.
       // myTextView.layer.borderColor = UIColor.blackColor().CGColor
        
        // フォントの設定をする.
        myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
        
        // フォントの色の設定をする.
        myTextView.textColor = UIColor.whiteColor()
        
        // 左詰めの設定をする.
        myTextView.textAlignment = NSTextAlignment.Left
        
        // リンク、日付などを自動的に検出してリンクに変換する.
        myTextView.dataDetectorTypes = UIDataDetectorTypes.All
        
        // 影の濃さを設定する.
        //myTextView.layer.shadowOpacity = 0.5
        
        // テキストを編集不可にする.
        myTextView.editable = false
        self.view.addSubview(myTextView)
        self.view.sendSubviewToBack(myTextView)
        
        
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}

