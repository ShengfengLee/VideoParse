//
//  ViewController.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func go(_ sender: Any) {
        guard let text = self.textField.text else { return }
        web(text)
    }

    @IBAction func baidu(_ sender: Any) {
        web("https://www.baidu.com")
    }

    @IBAction func youtube(_ sender: Any) {
        web("https://www.youtube.com")
    }

    @IBAction func facebook(_ sender: Any) {
        web("https://www.facebook.com")
    }

    @IBAction func tencent(_ sender: Any) {
        web("https://v.qq.com/")
    }

    @IBAction func dailyMotion(_ sender: Any) {
        web("https://www.dailymotion.com/")
    }

    @IBAction func vimeo(_ sender: Any) {
        web("https://vimeo.com/")
    }

    func web(_ url: String) {
        let webVC = YouTubeWebViewController()
        webVC.absoluteString = url
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}

